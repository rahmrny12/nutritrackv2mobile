import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/screening_result_model.dart';
import 'package:nutritrack/data/repository/screening_repository.dart';
import 'package:nutritrack/view/pages/profile_page.dart';
import 'package:nutritrack/view/viewmodel/screening_state.dart';
import 'package:nutritrack/view/viewmodel/screening_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/theme_viewmodel.dart';

class GoutScreeningPage extends StatefulWidget {
  const GoutScreeningPage({super.key});

  @override
  State<GoutScreeningPage> createState() =>
      _GoutScreeningPageState();
}

class _GoutScreeningPageState
    extends State<GoutScreeningPage> {
  late ThemeViewModel _themeViewModel;
  late ScreeningViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _themeViewModel = ThemeViewModel();

    _viewModel = ScreeningViewModel(
      ScreeningRepository(ApiService()),
    );

    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final state = _viewModel.state;

    if (state.status == ScreeningStatus.success &&
        state.latestResult != null) {
      _showResultSheet(state.latestResult!);

      _viewModel.resetState();
    }

    if (state.status == ScreeningStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ??
                'Terjadi kesalahan',
          ),
        ),
      );

      _viewModel.resetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themeViewModel.currentTheme;
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor:
              theme.scaffoldBackgroundColor,

          appBar: _buildAppBar(),

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 16),

                      // ─────────────────────────────
                      // RISK FACTOR
                      // ─────────────────────────────

                      _buildSectionCard(
                        title: 'Risk Factor Score',
                        subtitle:
                            'Lifestyle & Riwayat',
                        children: [
                          _buildQuestion(
                            number: 1,
                            keyName:
                                'riwayatKeluarga',
                            question:
                                'Apakah ada anggota keluarga inti yang memiliki riwayat asam urat?',
                            options: const [
                              'Ya',
                              'Tidak',
                              'Tidak Tahu',
                            ],
                            selected: _viewModel
                                .form
                                .riwayatKeluarga,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 2,
                            keyName:
                                'pernahAsamUrat',
                            question:
                                'Apakah Anda pernah didiagnosis memiliki kadar asam urat tinggi?',
                            options: const [
                              'Pernah',
                              'Tidak Pernah',
                            ],
                            selected: _viewModel
                                .form
                                .pernahAsamUrat,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 3,
                            keyName:
                                'konsumsiPurin',
                            question:
                                'Seberapa sering Anda mengonsumsi makanan tinggi purin?',
                            options: const [
                              'Jarang',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .konsumsiPurin,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 4,
                            keyName:
                                'minumanManis',
                            question:
                                'Seberapa sering Anda mengonsumsi minuman manis atau bersoda?',
                            options: const [
                              'Tidak',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .minumanManis,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 5,
                            keyName:
                                'beratBadan',
                            question:
                                'Apakah Anda memiliki berat badan berlebih?',
                            options: const [
                              'Ya',
                              'Tidak',
                            ],
                            selected: _viewModel
                                .form
                                .beratBadan,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 6,
                            keyName:
                                'hipertensiGinjal',
                            question:
                                'Apakah Anda memiliki hipertensi atau gangguan ginjal?',
                            options: const [
                              'Ya',
                              'Tidak',
                            ],
                            selected: _viewModel
                                .form
                                .hipertensiGinjal,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 7,
                            keyName: 'alkohol',
                            question:
                                'Apakah Anda mengonsumsi alkohol?',
                            options: const [
                              'Tidak',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .alkohol,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ─────────────────────────────
                      // SYMPTOM
                      // ─────────────────────────────

                      _buildSectionCard(
                        title: 'Symptom Score',
                        subtitle:
                            'Gejala Klinis',
                        children: [
                          _buildQuestion(
                            number: 8,
                            keyName:
                                'nyeriSendi',
                            question:
                                'Apakah Anda mengalami nyeri sendi mendadak terutama malam hari?',
                            options: const [
                              'Tidak',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .nyeriSendi,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 9,
                            keyName:
                                'bengkakSendi',
                            question:
                                'Apakah sendi Anda pernah bengkak, merah, atau terasa panas?',
                            options: const [
                              'Tidak',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .bengkakSendi,
                          ),

                          const _SectionDivider(),

                          _buildQuestion(
                            number: 10,
                            keyName:
                                'nyeriIbuJari',
                            question:
                                'Apakah nyeri sering terjadi pada ibu jari kaki?',
                            options: const [
                              'Tidak',
                              'Kadang',
                              'Sering',
                            ],
                            selected: _viewModel
                                .form
                                .nyeriIbuJari,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              _buildBottomButton(),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────
  // APP BAR
  // ─────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    return AppBar(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () =>
            Navigator.maybePop(context),
      ),
      title: const Text(
        'Parameter Khusus',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
    );
  }

  // ─────────────────────────────
  // HEADER
  // ─────────────────────────────

  Widget _buildHeader() {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withOpacity(0.8),
            colors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.2),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.monitor_heart_rounded,
              color: colors.onPrimary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Skrining Asam Urat',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Penilaian risiko berdasarkan faktor gaya hidup dan gejala klinis.',
                  style: TextStyle(
                    color: colors.onPrimary
                        .withOpacity(0.85),
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  // SECTION CARD
  // ─────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              colors.onSurface.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  colors.primary.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.onSurface
                        .withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          ...children,
        ],
      ),
    );
  }

  // ─────────────────────────────
  // QUESTION
  // ─────────────────────────────

  Widget _buildQuestion({
    required int number,
    required String keyName,
    required String question,
    required List<String> options,
    required String? selected,
  }) {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.only(
                  right: 8,
                ),
                decoration: BoxDecoration(
                  color: selected != null
                      ? colors.primary
                      : colors.onSurface
                          .withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: selected != null
                        ? colors.onPrimary
                        : colors.primary,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight:
                        FontWeight.w500,
                    color: colors.onSurface,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((e) {
              return _buildOptionChip(
                label: e,
                isSelected:
                    selected == e,
                onTap: () {
                  _viewModel.updateAnswer(
                    key: keyName,
                    value: e,
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  // OPTION CHIP
  // ─────────────────────────────

  Widget _buildOptionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary
              : colors.surface,
          borderRadius:
              BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.onSurface
                    .withOpacity(0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colors.onPrimary
                : colors.onSurface,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  // BOTTOM BUTTON
  // ─────────────────────────────

  Widget _buildBottomButton() {
    final colors =
        _themeViewModel.currentTheme.colorScheme;

    final state = _viewModel.state;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 +
            MediaQuery.of(context)
                .padding
                .bottom,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color:
                colors.onSurface.withOpacity(
              0.08,
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _viewModel.isCompleted &&
                  state.status !=
                      ScreeningStatus.loading
              ? _viewModel.saveResult
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            disabledBackgroundColor:
                colors.onSurface
                    .withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
          child: state.status ==
                  ScreeningStatus.loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Simpan & Lanjut',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  // RESULT SHEET
  // ─────────────────────────────

  void _showResultSheet(
    ScreeningResultModel result,
  ) {
    String description;
    Color color;

    switch (result.level) {
      case 'Risiko Tinggi':
        color = Colors.red;

        description =
            'Gejala klinis cukup kuat mengarah pada risiko asam urat tinggi. Disarankan melakukan pemeriksaan laboratorium dan konsultasi medis.';
        break;

      case 'Risiko Sedang':
        color = Colors.orange;

        description =
            'Terdapat beberapa faktor risiko dan gejala yang perlu diperhatikan. Perbaiki pola hidup dan pertimbangkan pemeriksaan lanjutan.';
        break;

      default:
        color = Colors.green;

        description =
            'Risiko asam urat tergolong rendah. Tetap pertahankan pola makan dan gaya hidup sehat.';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ResultSheet(
        level: result.level,
        skor: result.totalScore,
        riskFactorScore:
            result.riskFactorScore,
        symptomScore:
            result.symptomScore,
        modifierScore:
            result.modifierScore,
        description: description,
        color: color,
        onNext: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ProfilePage(),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DIVIDER
// ─────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    final colors =
        ThemeViewModel().currentTheme.colorScheme;

    return Divider(
      height: 1,
      thickness: 1,
      color:
          colors.onSurface.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }
}

// ─────────────────────────────────────────────
// RESULT SHEET
// ─────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  final String level;
  final int skor;
  final int riskFactorScore;
  final int symptomScore;
  final int modifierScore;
  final String description;
  final Color color;
  final VoidCallback? onNext;

  const _ResultSheet({
    required this.level,
    required this.skor,
    required this.riskFactorScore,
    required this.symptomScore,
    required this.modifierScore,
    required this.description,
    required this.color,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        ThemeViewModel().currentTheme;

    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius:
                  BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              level == 'Risiko Rendah'
                  ? Icons
                      .check_circle_rounded
                  : level ==
                          'Risiko Sedang'
                      ? Icons
                          .warning_rounded
                      : Icons
                          .dangerous_rounded,
              size: 56,
              color: color,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            level,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Total Score: $skor',
            style: TextStyle(
              color: colors.onSurface
                  .withOpacity(0.6),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  colors.primary.withOpacity(
                0.08,
              ),
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color: colors.onSurface
                    .withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                _buildScoreRow(
                  'Risk Factor Score',
                  riskFactorScore,
                ),

                const SizedBox(height: 10),

                _buildScoreRow(
                  'Symptom Score',
                  symptomScore,
                ),

                const SizedBox(height: 10),

                _buildScoreRow(
                  'Riwayat Modifier',
                  modifierScore,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                onNext?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1A8A7A),
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: const Text(
                'Simpan & Lanjut',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
    String label,
    int value,
  ) {
    final colors =
        ThemeViewModel().currentTheme.colorScheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: colors.onSurface
                .withOpacity(0.7),
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color:
                colors.primary.withOpacity(
              0.12,
            ),
            borderRadius:
                BorderRadius.circular(8),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}