import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/meal_log_model.dart';
import 'package:nutritrack/data/repository/meal_log_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const Color teal = Color(0xFF2BBFAC);
  static const Color tealDark = Color(0xFF1FA899);
  static const Color tealLight = Color(0xFFE8F9F7);
  static const Color tealMid = Color(0xFFC0EDE8);
  static const Color textMain = Color(0xFF1A2E2B);
  static const Color textSub = Color(0xFF6B8C88);
  static const Color textLabel = Color(0xFFAAC4C1);
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFE0F0EE);

  final MealLogRepository _mealLogRepo = MealLogRepository(ApiService());
  final List<Map<String, dynamic>> days = [
    {'label': 'Sun', 'num': 4},
    {'label': 'Mon', 'num': 5},
    {'label': 'Tue', 'num': 6},
    {'label': 'Wed', 'num': 7},
    {'label': 'Thu', 'num': 8},
    {'label': 'Fri', 'num': 9},
    {'label': 'Sat', 'num': 10},
  ];

  bool _isLoading = true;
  String? _error;
  List<MealLogModel> _mealLogs = [];
  int selectedDay = 4;
  static const int targetKcal = 2000;

  double get totalKcal =>
      _mealLogs.fold(0.0, (sum, log) => sum + log.totalCalories);

  @override
  void initState() {
    super.initState();
    _fetchMealLogs();
  }

  Future<void> _fetchMealLogs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final logs = await _mealLogRepo.fetchMealLogs();
      setState(() {
        _mealLogs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchMealLogs,
              color: teal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_isLoading) ...[
                      const SizedBox(height: 24),
                      const Center(child: CircularProgressIndicator()),
                    ] else if (_error != null) ...[
                      const SizedBox(height: 24),
                      _buildErrorCard(_error!),
                    ] else if (_mealLogs.isEmpty) ...[
                      const SizedBox(height: 24),
                      _buildEmptyCard(),
                    ] else ...[
                      ..._mealLogs.map((log) => _buildMealLogCard(log)),
                      const SizedBox(height: 16),
                      _buildTotalCard(),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 22,
                        ),
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
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 255, 255, 0.65),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isActive
                    ? [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${days[index]['num']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? tealDark
                      : const Color.fromRGBO(255, 255, 255, 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealLogCard(MealLogModel log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: tealLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.mealType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(log.createdAt),
                      style: const TextStyle(fontSize: 12, color: textSub),
                    ),
                  ],
                ),
                Text(
                  '${log.totalCalories} kcal',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: tealDark,
                  ),
                ),
              ],
            ),
          ),
          ...log.foodLogs.map((item) => _buildFoodLogItem(item)),
        ],
      ),
    );
  }

  Widget _buildFoodLogItem(FoodLogModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tealLight,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              item.type == 'recipe' ? '🍽️' : '🥬',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _foodLabel(item),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _foodSubtitle(item),
                  style: const TextStyle(fontSize: 12, color: textSub),
                ),
              ],
            ),
          ),
          Text(
            '${item.quantity}${item.type == 'ingredient' ? 'g' : 'x'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: tealDark,
            ),
          ),
        ],
      ),
    );
  }

  String _foodLabel(FoodLogModel item) {
    if (item.nameManual != null && item.nameManual!.isNotEmpty) {
      return item.nameManual!;
    }

    if (item.type == 'ingredient') {
      return item.ingredient?.name ?? 'Unknown Ingredient';
    }

    if (item.type == 'recipe') {
      return item.recipe?.name ?? 'Unknown Recipe';
    }

    return item.type;
  }

  String _foodSubtitle(FoodLogModel item) {
    final parts = <String>[];
    parts.add(item.type == 'ingredient' ? 'Bahan' : 'Resep');

    if (item.type == 'ingredient' && item.ingredientId != null) {
      parts.add('ID ${item.ingredientId}');
    }
    if (item.type == 'recipe' && item.recipeId != null) {
      parts.add('ID ${item.recipeId}');
    }
    if (item.caloriesManual != null) {
      parts.add('${item.caloriesManual!.toInt()} kcal');
    }

    return parts.join(' • ');
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: _fetchMealLogs,
            child: const Icon(Icons.refresh, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tealMid, width: 1.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🍽️', style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text(
            'Belum ada catatan makanan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textLabel,
            ),
          ),
        ],
      ),
    );
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Kalori Riwayat',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textSub,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$totalKcal ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textMain,
                      ),
                    ),
                    const TextSpan(
                      text: 'kcal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
              Text(
                '0 KCAL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textLabel,
                ),
              ),
              Text(
                'TARGET: 2000 KCAL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: tealDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textSub,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
