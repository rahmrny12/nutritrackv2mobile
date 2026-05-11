import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF2FAF9),
      ),
      home: const HistoryPage(),
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────
class FoodItem {
  final String emoji;
  final String name;
  final String portion;
  final int kcal;
  FoodItem({required this.emoji, required this.name, required this.portion, required this.kcal});
}

class MealSection {
  final String title;
  final List<FoodItem> items;
  MealSection({required this.title, required this.items});
}

// ── Page ─────────────────────────────────────────────────────────────────────
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const Color teal     = Color(0xFF2BBFAC);
  static const Color tealDark = Color(0xFF1FA899);
  static const Color tealLight= Color(0xFFE8F9F7);
  static const Color tealMid  = Color(0xFFC0EDE8);
  static const Color textMain = Color(0xFF1A2E2B);
  static const Color textSub  = Color(0xFF6B8C88);
  static const Color textLabel= Color(0xFFAAC4C1);
  static const Color cardBg   = Colors.white;
  static const Color border   = Color(0xFFE0F0EE);

  int selectedDay = 4; // index 0–6 → Sun=0 … Sat=6; Fri=4 (index 5 in list below, value=9)
  // Days: Sun4, Mon5, Tue6, Wed7, Thu8, Fri9, Sat10
  final List<Map<String, dynamic>> days = [
    {'label': 'Sun', 'num': 4},
    {'label': 'Mon', 'num': 5},
    {'label': 'Tue', 'num': 6},
    {'label': 'Wed', 'num': 7},
    {'label': 'Thu', 'num': 8},
    {'label': 'Fri', 'num': 9},
    {'label': 'Sat', 'num': 10},
  ];

  final List<MealSection> meals = [
    MealSection(title: 'Sarapan', items: [
      FoodItem(emoji: '🥣', name: 'Oatmeal Pisang',   portion: '1 Mangkuk (250g)', kcal: 320),
      FoodItem(emoji: '☕', name: 'Kopi Susu',         portion: '1 Gelas (200ml)',  kcal: 85),
    ]),
    MealSection(title: 'Makan Siang', items: [
      FoodItem(emoji: '🍛', name: 'Nasi Campur Bali', portion: '1 Porsi Lengkap',  kcal: 540),
    ]),
    MealSection(title: 'Makan Malam', items: []),
  ];

  int get totalKcal => meals.expand((m) => m.items).fold(0, (s, i) => s + i.kcal);
  static const int targetKcal = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...meals.map((m) => _buildMealSection(m)),
                  _buildTotalCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [teal, tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              // Title row
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  const Text(
                    'Riwayat Makanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Day selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(days.length, (i) => _buildDayItem(i)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayItem(int index) {
    final bool isActive = index == selectedDay;
    return GestureDetector(
      onTap: () => setState(() => selectedDay = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              days[index]['label'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.65),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isActive
                    ? [const BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${days[index]['num']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive ? tealDark : Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Meal Section ──────────────────────────────────────────────────────────
  Widget _buildMealSection(MealSection meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: teal, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      meal.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textMain,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showAddSnack(meal.title),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 30, height: 30,
                    decoration: const BoxDecoration(color: tealLight, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, color: teal, size: 18),
                  ),
                ),
              ],
            ),
          ),
          // Items or empty
          if (meal.items.isEmpty)
            _buildEmptyCard()
          else
            ...meal.items.map((item) => _buildFoodCard(item)),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // left accent bar
              Container(width: 3, color: teal),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: tealLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.name,
                              style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700, color: textMain,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(item.portion,
                              style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500, color: textSub,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.kcal} kcal',
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800, color: tealDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tealMid, width: 1.5,
          // dashed not supported natively; use a solid lighter border
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🍽️', style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text(
            'Belum ada makanan dicatat',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textLabel),
          ),
        ],
      ),
    );
  }

  // ── Total Card ────────────────────────────────────────────────────────────
  Widget _buildTotalCard() {
    final double progress = (totalKcal / targetKcal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Kalori Hari Ini',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSub),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$totalKcal ',
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: textMain,
                      ),
                    ),
                    const TextSpan(
                      text: 'kcal',
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: tealLight,
              valueColor: const AlwaysStoppedAnimation<Color>(teal),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 KCAL',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textLabel),
              ),
              Text('TARGET: 2000 KCAL',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textLabel),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Macro chips
          Row(
            children: [
              _buildMacroChip('42g', 'Protein'),
              const SizedBox(width: 8),
              _buildMacroChip('118g', 'Karbo'),
              const SizedBox(width: 8),
              _buildMacroChip('28g', 'Lemak'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: tealLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
              style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: tealDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
              style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: textSub,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _showAddSnack(String mealName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tambah makanan ke $mealName'),
        backgroundColor: teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}