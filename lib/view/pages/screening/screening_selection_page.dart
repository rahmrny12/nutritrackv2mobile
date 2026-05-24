import 'package:flutter/material.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/view/viewmodel/theme_viewmodel.dart';

class ScreeningSelectionPage extends StatefulWidget {
  const ScreeningSelectionPage({super.key});

  @override
  State<ScreeningSelectionPage> createState() => _ScreeningSelectionPageState();
}

class _ScreeningSelectionPageState extends State<ScreeningSelectionPage> {
  late ThemeViewModel _themeViewModel;

  final List<Map<String, dynamic>> _options = [
    {
      'title': 'Skrining Asam Urat',
      'subtitle': 'Deteksi kondisi asam urat dan rekomendasi pola makan',
      'icon': Icons.health_and_safety_outlined,
      'route': Routes.gout_screening,
    },
    {
      'title': 'Skrining Diabetes',
      'subtitle': 'Cek risiko diabetes dan kebiasaan gula darah',
      'icon': Icons.monitor_heart_outlined,
      'route': Routes.diabetes_screening,
    },
    {
      'title': 'Skrining Jantung',
      'subtitle': 'Evaluasi risiko kesehatan jantung dan aktivitas harian',
      'icon': Icons.favorite_outline,
      'route': Routes.heart_screening,
    },
  ];

  @override
  void initState() {
    super.initState();
    _themeViewModel = ThemeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themeViewModel.currentTheme;
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Pilih Skrining',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih jenis skrining yang ingin kamu lakukan hari ini.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ..._options.map((option) => _buildOptionCard(option, colors)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> option, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, option['route'] as String),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.onSurface.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option['icon'] as IconData,
                    size: 24,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        option['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurface.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colors.onSurface.withOpacity(0.65),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
