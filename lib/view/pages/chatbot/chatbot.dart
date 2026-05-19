// pubspec.yaml - tambahkan dependency ini:
// dependencies:
//   http: ^1.2.0

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asisten Kesehatan AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF2FAF9),
      ),
      home: const ChatbotPage(),
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────
enum MsgType { text, doctorCard }

class ChatMessage {
  final String? text;
  final bool isUser;
  final String time;
  final MsgType type;
  ChatMessage({this.text, required this.isUser, required this.time, this.type = MsgType.text});
}

// ── Page ─────────────────────────────────────────────────────────────────────
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  static const Color teal      = Color(0xFF2BBFAC);
  static const Color tealDark  = Color(0xFF1FA899);
  static const Color tealXDark = Color(0xFF0F6E56);
  static const Color tealLight = Color(0xFFE8F9F7);
  static const Color tealMid   = Color(0xFFC0EDE8);
  static const Color textMain  = Color(0xFF1A2E2B);
  static const Color textSub   = Color(0xFF6B8C88);
  static const Color textHint  = Color(0xFFAAC4C1);
  static const Color cardBg    = Colors.white;
  static const Color border    = Color(0xFFE0F0EE);
  static const Color bgColor   = Color(0xFFF2FAF9);
  static const Color starColor = Color(0xFFF59E0B);

  // ⚠️ Ganti dengan API key kamu
  static const String _apiKey = 'sk-ant-api03-xxxx';

  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _jadwalDone = false;
  bool _isLoading = false;

  // Riwayat untuk konteks AI (format Anthropic)
  final List<Map<String, String>> _history = [];

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Halo! Berdasarkan hasil skrining yang baru saja Anda isi, sistem mendeteksi adanya Risiko Tinggi untuk Diabetes Mellitus.',
      isUser: false, time: '10:42',
    ),
    ChatMessage(
      text: 'Untuk memastikan kondisi Anda dan mendapatkan diagnosis serta penanganan yang tepat, kami sangat menyarankan Anda untuk berkonsultasi dengan dokter spesialis.',
      isUser: false, time: '10:43',
    ),
    ChatMessage(
      text: 'Apakah Anda ingin saya bantu mencari jadwal konsultasi dengan dokter spesialis penyakit dalam (Sp.PD) terdekat atau secara online?',
      isUser: false, time: '10:43',
    ),
    ChatMessage(
      text: 'Ya, tolong carikan jadwal dokter untuk konsultasi online hari ini.',
      isUser: true, time: '10:50',
    ),
    ChatMessage(
      text: 'Baik. Berikut adalah rekomendasi dokter spesialis yang tersedia untuk konsultasi online hari ini:',
      isUser: false, time: '10:52',
    ),
    ChatMessage(isUser: false, time: '10:52', type: MsgType.doctorCard),
  ];

  final List<Map<String, String>> _quickReplies = [
    {'label': 'Dokter lain',      'text': 'Tampilkan dokter spesialis lain yang tersedia'},
    {'label': 'Biaya konsultasi', 'text': 'Berapa biaya konsultasi online?'},
    {'label': 'Persiapan',        'text': 'Apa yang harus dipersiapkan sebelum konsultasi?'},
  ];

  @override
  void initState() {
    super.initState();
    // Isi history awal sesuai percakapan yang sudah tampil
    _history.addAll([
      {'role': 'assistant', 'content': 'Halo! Berdasarkan hasil skrining yang baru saja Anda isi, sistem mendeteksi adanya Risiko Tinggi untuk Diabetes Mellitus.'},
      {'role': 'assistant', 'content': 'Untuk memastikan kondisi Anda dan mendapatkan diagnosis serta penanganan yang tepat, kami sangat menyarankan Anda untuk berkonsultasi dengan dokter spesialis.'},
      {'role': 'assistant', 'content': 'Apakah Anda ingin saya bantu mencari jadwal konsultasi dengan dokter spesialis penyakit dalam (Sp.PD) terdekat atau secara online?'},
      {'role': 'user',      'content': 'Ya, tolong carikan jadwal dokter untuk konsultasi online hari ini.'},
      {'role': 'assistant', 'content': 'Baik. Berikut adalah rekomendasi dokter spesialis yang tersedia: dr. Budi Santoso, Sp.PD (Rating 4.9, Tersedia pukul 16:00).'},
    ]);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _now() {
    final t = TimeOfDay.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // ── Anthropic API Call ────────────────────────────────────────────────────
  Future<String> _getAIReply(String userMsg) async {
    try {
      // Tambah pesan user ke history
      _history.add({'role': 'user', 'content': userMsg});

      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 500,
          'system': '''Kamu adalah Asisten Kesehatan AI yang ramah dan profesional.
Kamu membantu pengguna yang memiliki risiko Diabetes Mellitus berdasarkan hasil skrining.
Jawab selalu dalam Bahasa Indonesia yang sopan, jelas, dan mudah dipahami.
Berikan saran kesehatan yang akurat namun tetap ingatkan pengguna untuk berkonsultasi dengan dokter.
Jangan memberikan diagnosis pasti — kamu hanya asisten, bukan dokter.
Jawaban singkat dan padat, maksimal 3 kalimat.''',
          'messages': _history,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['content'][0]['text'] as String;
        // Tambah balasan AI ke history
        _history.add({'role': 'assistant', 'content': reply});
        return reply;
      } else {
        _history.removeLast(); // hapus user msg kalau gagal
        return 'Maaf, terjadi gangguan koneksi. Silakan coba lagi.';
      }
    } catch (e) {
      _history.removeLast();
      return 'Maaf, tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }
  }

  // ── Send ──────────────────────────────────────────────────────────────────
  void _send([String? override]) async {
    final txt = override ?? _ctrl.text.trim();
    if (txt.isEmpty || _isLoading) return;
    _ctrl.clear();

    setState(() {
      _messages.add(ChatMessage(text: txt, isUser: true, time: _now()));
      _isLoading = true;
    });
    _scrollDown();

    final reply = await _getAIReply(txt);

    setState(() {
      _isLoading = false;
      _messages.add(ChatMessage(text: reply, isUser: false, time: _now()));
    });
    _scrollDown();
  }

  void _jadwalkan() {
    if (_jadwalDone) return;
    setState(() {
      _jadwalDone = true;
      _messages.add(ChatMessage(
        text: 'Konsultasi dengan dr. Budi Santoso, Sp.PD berhasil dijadwalkan pukul 16:00 hari ini. Notifikasi akan dikirim 15 menit sebelum sesi dimulai. ✓',
        isUser: false, time: _now(),
      ));
    });
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatArea()),
          _buildQuickReplies(),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: teal,
      elevation: 0,
      leading: IconButton(
  icon: const Icon(Icons.arrow_back, color: Colors.white),
  onPressed: () {
    Navigator.pushReplacementNamed(context, '/dashboard');
  },
),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Center(child: Text('🩺', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Asisten Kesehatan AI',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
              Row(
                children: [
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA7F3D0), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLoading ? 'Mengetik...' : 'Online',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call, color: Colors.white, size: 20), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.white, size: 20), onPressed: () {}),
      ],
    );
  }

  // ── Chat Area ─────────────────────────────────────────────────────────────
  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(14),
      itemCount: _messages.length + (_isLoading ? 2 : 1),
      itemBuilder: (ctx, i) {
        if (i == 0) return _buildDateDivider();
        final idx = i - 1;
        if (idx < _messages.length) {
          final msg = _messages[idx];
          if (msg.type == MsgType.doctorCard) return _buildDoctorCard();
          return _buildMsgRow(msg);
        }
        // Loading bubble
        return _buildLoadingBubble();
      },
    );
  }

  Widget _buildDateDivider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: Text('Hari ini, 10:42',
          style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600,
            color: textHint, letterSpacing: .5)),
      ),
    );
  }

  Widget _buildMsgRow(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[_botAvatar(), const SizedBox(width: 8)],
          Column(
            crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _buildBubble(msg),
              const SizedBox(height: 3),
              Text(msg.time,
                style: const TextStyle(fontSize: 10, color: textHint, fontWeight: FontWeight.w500)),
            ],
          ),
          if (msg.isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _botAvatar() {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: tealLight,
        shape: BoxShape.circle,
        border: Border.all(color: tealMid, width: 1.5),
      ),
      child: const Center(child: Text('🩺', style: TextStyle(fontSize: 14))),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    final maxW = MediaQuery.of(context).size.width * 0.65;
    return Container(
      constraints: BoxConstraints(maxWidth: maxW),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: msg.isUser ? teal : cardBg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
          bottomRight: Radius.circular(msg.isUser ? 4 : 18),
        ),
        border: msg.isUser ? null : Border.all(color: border, width: 1.5),
      ),
      child: Text(msg.text ?? '',
        style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: msg.isUser ? Colors.white : textMain,
          height: 1.55,
        )),
    );
  }

  // ── Loading Bubble (animasi titik) ────────────────────────────────────────
  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _botAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: border, width: 1.5),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ── Doctor Card ───────────────────────────────────────────────────────────
  Widget _buildDoctorCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 36),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 230,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: tealLight,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: tealMid, shape: BoxShape.circle),
                      child: const Center(child: Text('👨‍⚕️', style: TextStyle(fontSize: 18))),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('dr. Budi Santoso, Sp.PD',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: tealXDark)),
                        SizedBox(height: 2),
                        Text('Spesialis Penyakit Dalam',
                          style: TextStyle(fontSize: 10, color: textSub, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(children: List.generate(5, (_) =>
                          const Icon(Icons.star, color: starColor, size: 13))),
                        const SizedBox(width: 6),
                        const Text('4.9',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textMain)),
                        const SizedBox(width: 4),
                        const Text('(320)',
                          style: TextStyle(fontSize: 11, color: textHint)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 7, height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        const Text('Tersedia · 16:00',
                          style: TextStyle(fontSize: 11, color: textSub, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _jadwalkan,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: _jadwalDone ? tealDark : teal,
                  child: Center(
                    child: Text(
                      _jadwalDone ? '✓ Terjadwal' : 'Jadwalkan Konsultasi',
                      style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Quick Replies ─────────────────────────────────────────────────────────
  Widget _buildQuickReplies() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _quickReplies.map((qr) => Padding(
            padding: const EdgeInsets.only(right: 7),
            child: GestureDetector(
              onTap: () => _send(qr['text']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tealMid, width: 1.5),
                ),
                child: Text(qr['label']!,
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: tealXDark)),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  // ── Input Bar ─────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      decoration: const BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: border, width: 1.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: const BoxDecoration(color: tealLight, shape: BoxShape.circle),
            child: const Icon(Icons.attach_file, color: teal, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(fontSize: 13, color: textMain),
              onSubmitted: (_) => _send(),
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: _isLoading ? 'AI sedang mengetik...' : 'Ketik pesan di sini...',
                hintStyle: const TextStyle(color: textHint, fontSize: 13),
                filled: true,
                fillColor: bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: border, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: teal, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _send,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _isLoading ? tealMid : teal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Dots Animation ─────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    ));
    _anims = _controllers.map((c) =>
      Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut))).toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: _anims[i],
        builder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          transform: Matrix4.translationValues(0, _anims[i].value, 0),
          width: 7, height: 7,
          decoration: const BoxDecoration(
            color: Color(0xFF2BBFAC), shape: BoxShape.circle),
        ),
      )),
    );
  }
}