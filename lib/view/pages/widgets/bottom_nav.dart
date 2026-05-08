import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  static const Color _teal = Color(0xFF2ABFB0);

  final items = const [
    {'icon': Icons.home_rounded, 'label': 'Beranda'},
    {'icon': Icons.book_outlined, 'label': 'Diary'},
    {'icon': Icons.bar_chart, 'label': 'Progres'},
    {'icon': Icons.person_outline, 'label': 'Profil'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onIndexChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[index]['icon'] as IconData,
                  color: isSelected ? _teal : const Color(0xFFBBBBBB),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? _teal : const Color(0xFFBBBBBB),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
