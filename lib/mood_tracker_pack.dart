import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  double stressLevel = 4.0;
  String selectedEnergy = 'Normal';

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MoodEmoji(emoji: "😊", label: "Senang"),
                        _MoodEmoji(emoji: "😐", label: "Biasa"),
                        _MoodEmoji(emoji: "😣", label: "Sedih"),
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
                      onChanged: (value) => setState(() => stressLevel = value),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tenang", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("Sangat Stres", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Energi", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _EnergyBtn(label: "Low", isSelected: selectedEnergy == "Low", onTap: () => setState(() => selectedEnergy = "Low")),
                        _EnergyBtn(label: "Normal", isSelected: selectedEnergy == "Normal", onTap: () => setState(() => selectedEnergy = "Normal")),
                        _EnergyBtn(label: "High", isSelected: selectedEnergy == "High", onTap: () => setState(() => selectedEnergy = "High")),
                      ],
                    )
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
            const Text("Trend Mingguan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        _Legend(color: Colors.green[900]!, label: "Mood"),
                        const SizedBox(width: 15),
                        _Legend(color: Colors.blue[700]!, label: "Stres"),
                        const Spacer(),
                        const Text("Feb 1 - Feb 7", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 150,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  return Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10));
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            _chartData(0, 8, isSpecial: true),
                            _chartData(1, 3),
                            _chartData(2, 6),
                            _chartData(3, 4),
                            _chartData(4, 2),
                            _chartData(5, 5),
                            _chartData(6, 4),
                          ],
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

  BarChartGroupData _chartData(int x, double y, {bool isSpecial = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isSpecial ? const Color(0xFF1B5E20) : const Color(0xFF1A73E8),
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}

class _MoodEmoji extends StatelessWidget {
  final String emoji, label;
  const _MoodEmoji({required this.emoji, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _EnergyBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _EnergyBtn({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00796B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
        ),
      ),
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