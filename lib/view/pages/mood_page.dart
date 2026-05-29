import 'package:nutritrack/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {


  final TextEditingController noteController = TextEditingController();
  double stressLevel = 4.0;
  int selectedMood = 3;

  List<Map<String, dynamic>> moods = [];
  @override
  void initState() {
    super.initState();
    fetchMoods(); // 🔥 ini yang auto ambil data pas halaman dibuka
  }

  Future<void> fetchMoods() async {
    print("TOKEN FETCH: ${AuthStore.token}");
  try {
    final response = await http.get(
      Uri.parse("http://192.168.1.7:8000/api/moods"),
      headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${AuthStore.token}",
    }
    );

    print("RESPONSE: ${response.body}");
  

    final data = jsonDecode(response.body);

    setState(() {
      if (data['data'] != null && data['data'] is List) {
      final allMoods = List<Map<String, dynamic>>.from(data['data']);
      final now = DateTime.now();
      moods = allMoods.where((mood) {
        final createdAt = DateTime.parse(mood['created_at']);
        return now.difference(createdAt).inDays <= 7;
      }).toList();
      moods.sort((a, b) =>
      DateTime.parse(a['created_at'])
      .compareTo(DateTime.parse(b['created_at']))
);

      final uniqueMoods = <String, Map<String, dynamic>>{};

      for (var mood in moods) {
        final dateKey =
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(mood['created_at']));

        uniqueMoods[dateKey] = mood;
      }

      moods = uniqueMoods.values.toList();

      } else {
        moods = [];
      }

      if (moods.isNotEmpty) {
        selectedMood = moods.last['mood_level'] ?? 3;

        stressLevel =
            (moods.last['stress_level'] ?? 4).toDouble();
      }
    });
  } catch (e) {
    print("Fetch error: $e");
  }
}

Future<void> submitMood() async {
  print("TOKEN SUBMIT: ${AuthStore.token}");
  try {
    final response = await http.post(
      Uri.parse("http://192.168.1.7:8000/api/moods"),
      headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${AuthStore.token}",
    },
      
      body: jsonEncode({
      "mood_level": selectedMood,
      "stress_level": stressLevel.toInt(),
      "note": noteController.text,
    }),
    );

     if (response.statusCode >= 200 &&
        response.statusCode < 300) {

      await fetchMoods();

      print("Mood berhasil disimpan");
    } else {
      print("Gagal simpan mood");
    }

  } catch (e) {
    print("Error: $e");
  }
}

  @override
  void dispose() {
  noteController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE0F2F1),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 15, color: Color(0xFF00796B)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text("stres dan mood", style: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bagaimana perasaanmu?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 20),
            
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedMood = 5;
                          });

                        },
                        child: _MoodEmoji(
                        emoji: "😊",
                        label: "Senang",
                        isSelected: selectedMood == 5,
                      ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedMood = 3;
                          });
                        },
                        child: _MoodEmoji(
                        emoji: "😐",
                        label: "Biasa",
                        isSelected: selectedMood == 3,
                      ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedMood = 1;
                          });
                        },
                        child: _MoodEmoji(
                        emoji: "😣",
                        label: "Sedih",
                        isSelected: selectedMood == 1,
                      ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Level Stres", style: TextStyle(color: Colors.grey)),
                        Text("${stressLevel.toInt()} / 10", 
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                      ],
                    ),
                    Slider(
                      value: stressLevel,
                      max: 10,
                      divisions: 10,
                      activeColor: const Color(0xFF00796B),
                      inactiveColor: Colors.grey[200],
                      onChanged: (value) {
                        setState(() {
                          stressLevel = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tenang",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          "Sangat Stres",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Catatan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Tulis perasaanmu hari ini...",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7F9),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFF1A8A7A),
                            width: 1.5,
                          ),
                        ),

                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await submitMood();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Mood berhasil disimpan ✨"),
                              backgroundColor: Color(0xFF1A8A7A),
                            ),
                          );

                          noteController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A8A7A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Simpan Mood",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00796B),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.white, size: 30),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("INSIGHT PINTAR", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(
                          "Saat kurang tidur, stresmu naik. Hari olahraga = mood lebih baik.",
                          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Trend 7 Hari Terakhir",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              moods.isNotEmpty
                  ? "${DateFormat('d MMM').format(DateTime.parse(moods.first['created_at']))} - "
                    "${DateFormat('d MMM yyyy').format(DateTime.parse(moods.last['created_at']))}"
                  : "-",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _Legend(color: Colors.green.shade900, label: "Mood"),
                        const SizedBox(width: 15),
                        _Legend(color: Colors.blue.shade700, label: "Stres"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                              if (value.toInt() >= moods.length) {
                                return const Text('');
                              }

                              final date = DateTime.parse(moods[value.toInt()]['created_at']);

                              return Text(
                              DateFormat('d MMM').format(date),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                            },
                            ),
                          ),
                        ),
                        barGroups: List.generate(moods.length, (i) {
                          final mood = moods[i];

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                            BarChartRodData(
                              toY: (mood['mood_level'] ?? 0).toDouble(),
                              width: 8,
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),

                            BarChartRodData(
                              toY: (mood['stress_level'] ?? 0).toDouble(),
                              width: 8,
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                          );
                        }),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class _MoodEmoji extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;

  const _MoodEmoji({
    required this.emoji,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFF1A8A7A).withOpacity(0.3),
                    const Color(0xFF23A18F).withOpacity(0.2),
                  ],
                )
              : null,
        ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}


class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}