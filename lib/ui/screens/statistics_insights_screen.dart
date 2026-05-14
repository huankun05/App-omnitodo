import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/responsive_navigation.dart';

// ============================================================================
// TODO(UI微调): Statistics Insights 页面样式参数
// ============================================================================
// 页面布局
const double kInsightPagePaddingH = 32.0; // 页面水平内边距
const double kInsightPagePaddingTop = 112.0; // 页面顶部内边距

// 统计卡片
const double kStatCardPadding = 32.0; // 卡片内边距
const double kStatCardRadius = 16.0; // 卡片圆角
const double kStatCardGap = 32.0; // 卡片间距
const double kStatCardHoverOffset = 4.0; // 悬停上移距离

// 标题样式
const double kPageTitleSize = 48.0; // 页面标题字体大小
const double kPageSubtitleSize = 18.0; // 页面副标题字体大小
const double kStatValueSize = 48.0; // 统计数字字体大小
const double kStatLabelSize = 12.0; // 统计标签字体大小
const double kSectionTitleSize = 20.0; // 区块标题字体大小

// 进度条
const double kProgressBarHeight = 8.0; // 进度条高度
const double kProgressBarRadius = 4.0; // 进度条圆角

// 热力图
const double kHeatmapCellSize = 14.0; // 热力图单元格大小
const double kHeatmapCellGap = 4.0; // 热力图单元格间距
const double kHeatmapCellRadius = 2.0; // 热力图单元格圆角

// AI Insights
const double kAIInsightsPadding = 32.0; // AI面板内边距
const double kAIInsightsRadius = 16.0; // AI面板圆角
const double kAIInsightsIconSize = 24.0; // AI图标大小
const double kAIInsightsItemPadding = 16.0; // AI洞察项内边距
const double kAIInsightsItemRadius = 12.0; // AI洞察项圆角

// 图表
const double kChartHeight = 256.0; // 图表高度
const double kDonutChartSize = 192.0; // 环形图尺寸
const double kChartBarGap = 12.0; // 柱状图间距
const double kChartBarRadius = 8.0; // 柱状图圆角

// 颜色
const Color kPrimaryBlue = Color(0xFF004AC6);
const Color kPrimaryBlueLight = Color(0xFF2563EB);
const Color kSecondaryOrange = Color(0xFFFD761A);
const Color kTertiaryRed = Color(0xFF943700);
const Color kSuccessGreen = Color(0xFF16A34A);
const Color kErrorRed = Color(0xFFDC2626);

const List<Color> kHeatmapColors = [
  Color(0xFFF3F4F6), // 无活动
  Color(0xFFBFDBFE), // 低活动
  Color(0xFF93C5FD), // 中低活动
  Color(0xFF60A5FA), // 中等活动
  Color(0xFF3B82F6), // 高活动
  Color(0xFF2563EB), // 最高活动
];
// ============================================================================

class StatisticsInsightsScreen extends ConsumerStatefulWidget {
  const StatisticsInsightsScreen({super.key});

  @override
  ConsumerState<StatisticsInsightsScreen> createState() =>
      _StatisticsInsightsScreenState();
}

class _StatisticsInsightsScreenState
    extends ConsumerState<StatisticsInsightsScreen> {
  String _selectedTrendPeriod = 'Week'; // Week / Month / Year

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isMobile = screenWidth < 768;

    return ResponsiveNavigation(
      currentPage: 'insights',
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : kInsightPagePaddingH,
              vertical: kInsightPagePaddingTop,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Header
                _buildPageHeader(),

                const SizedBox(height: 48), // TODO(UI微调): 标题与卡片间距

                // Summary Cards Grid
                _buildStatCardsGrid(isDesktop),

                const SizedBox(height: 48), // TODO(UI微调): 卡片与图表间距

                // Heatmap & AI Insights
                _buildHeatmapAndAIInsights(isDesktop),

                const SizedBox(height: 48), // TODO(UI微调): 上部与下部间距

                // Trends & Category
                _buildTrendsAndCategory(isDesktop),

                const SizedBox(height: 120), // 底部间距
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 页面标题
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights', // TODO(UI微调): 页面标题
          style: TextStyle(
            fontSize: kPageTitleSize,
            fontWeight: FontWeight.w800,
            fontFamily: 'Manrope',
            color: const Color(0xFF1A1C1D),
            letterSpacing: 1, // TODO(UI微调): 标题字间距
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your productivity journey, quantified.',
          style: TextStyle(
            fontSize: kPageSubtitleSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF737686),
          ),
        ),
      ],
    );
  }

  // 统计卡片网格
  Widget _buildStatCardsGrid(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: _buildTotalTasksCard()),
          const SizedBox(width: kStatCardGap),
          Expanded(child: _buildCompletionRateCard()),
          const SizedBox(width: kStatCardGap),
          Expanded(child: _buildFocusTimeCard()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildTotalTasksCard(),
          const SizedBox(height: kStatCardGap),
          _buildCompletionRateCard(),
          const SizedBox(height: kStatCardGap),
          _buildFocusTimeCard(),
        ],
      );
    }
  }

  // Total Tasks 卡片
  Widget _buildTotalTasksCard() {
    return _StatCard(
      icon: Icons.task_alt,
      iconColor: kPrimaryBlue,
      iconBgColor: const Color(0xFFDBEAFE),
      trendValue: '+12%',
      trendIsPositive: true,
      label: 'Total Tasks',
      value: '248',
      subtitle: 'Compared to last month',
    );
  }

  // Completion Rate 卡片
  Widget _buildCompletionRateCard() {
    return _StatCard(
      icon: Icons.speed,
      iconColor: kSecondaryOrange,
      iconBgColor: const Color(0xFFFFE4CC),
      trendValue: '+5%',
      trendIsPositive: true,
      label: 'Completion Rate',
      value: '85%',
      progress: 0.85,
      subtitle: 'Tasks completed on time',
    );
  }

  // Focus Time 卡片
  Widget _buildFocusTimeCard() {
    return _StatCard(
      icon: Icons.timer,
      iconColor: kPrimaryBlueLight,
      iconBgColor: const Color(0xFFDBEAFE),
      trendValue: '-2h',
      trendIsPositive: false,
      label: 'Focus Time',
      value: '142h 30m',
      subtitle: 'Deep work sessions active',
    );
  }

  // 热力图和 AI 洞察
  Widget _buildHeatmapAndAIInsights(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildConsistencyScoreCard()),
          const SizedBox(width: kStatCardGap),
          Expanded(flex: 1, child: _buildAIInsightsCard()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildConsistencyScoreCard(),
          const SizedBox(height: kStatCardGap),
          _buildAIInsightsCard(),
        ],
      );
    }
  }

  // Consistency Score 热力图卡片
  Widget _buildConsistencyScoreCard() {
    return Container(
      padding: const EdgeInsets.all(kStatCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kStatCardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和图例
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consistency Score', // TODO(UI微调): 热力图标题
                style: TextStyle(
                  fontSize: kSectionTitleSize,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                  color: const Color(0xFF1A1C1D),
                ),
              ),
              _buildHeatmapLegend(),
            ],
          ),
          const SizedBox(height: 24), // TODO(UI微调): 标题与热力图间距

          // 热力图
          _buildHeatmapGrid(),

          const SizedBox(height: 16), // TODO(UI微调): 热力图与月份标签间距

          // 月份标签
          _buildMonthLabels(),
        ],
      ),
    );
  }

  // 热力图图例
  Widget _buildHeatmapLegend() {
    return Row(
      children: [
        Text(
          'Less',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF737686),
          ),
        ),
        const SizedBox(width: 8),
        ...kHeatmapColors.map((color) => Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
        const SizedBox(width: 8),
        Text(
          'More',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF737686),
          ),
        ),
      ],
    );
  }

  // 热力图网格
  Widget _buildHeatmapGrid() {
    final random = Random(42); // 固定种子保证一致的随机数据
    final weeks = 52;
    final daysPerWeek = 7;

    return SizedBox(
      height: (kHeatmapCellSize * daysPerWeek) + (kHeatmapCellGap * (daysPerWeek - 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(weeks, (weekIndex) {
          return Column(
            children: List.generate(daysPerWeek, (dayIndex) {
              final intensity = random.nextInt(6);
              return Container(
                width: kHeatmapCellSize,
                height: kHeatmapCellSize,
                margin: EdgeInsets.only(
                  right: dayIndex == daysPerWeek - 1 ? 0 : kHeatmapCellGap,
                  bottom: kHeatmapCellGap,
                ),
                decoration: BoxDecoration(
                  color: kHeatmapColors[intensity],
                  borderRadius: BorderRadius.circular(kHeatmapCellRadius),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  // 月份标签
  Widget _buildMonthLabels() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: months.map((month) => Text(
        month,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF737686),
          letterSpacing: 1,
        ),
      )).toList(),
    );
  }

  // AI Insights 卡片
  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(kAIInsightsPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(kAIInsightsRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004AC6).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: kAIInsightsIconSize,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Insights',
                    style: TextStyle(
                      fontSize: kSectionTitleSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Manrope',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24), // TODO(UI微调): 标题与内容间距

              // 洞察项 1
              _buildAIInsightItem(
                'You are <b>24% more productive</b> on Tuesday mornings compared to other days.',
              ),
              const SizedBox(height: 16), // TODO(UI微调): 洞察项间距

              // 洞察项 2
              _buildAIInsightItem(
                'Your focus sessions peak when you start before <b>9:00 AM</b>.',
              ),
              const SizedBox(height: 24), // TODO(UI微调): 洞察与按钮间距

              // 优化按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 优化日程
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Optimize My Schedule',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 装饰背景
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            top: -24,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AI 洞察项
  Widget _buildAIInsightItem(String text) {
    return Container(
      padding: const EdgeInsets.all(kAIInsightsItemPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(kAIInsightsItemRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text.rich(
        TextSpan(
          text: '"',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          children: [
            TextSpan(
              text: text.replaceAll('<b>', '').replaceAll('</b>', ''),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            TextSpan(
              text: '"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 趋势和分类
  Widget _buildTrendsAndCategory(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: _buildProductivityTrendsCard()),
          const SizedBox(width: kStatCardGap),
          Expanded(flex: 5, child: _buildCategoryBreakdownCard()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildProductivityTrendsCard(),
          const SizedBox(height: kStatCardGap),
          _buildCategoryBreakdownCard(),
        ],
      );
    }
  }

  // Productivity Trends 卡片
  Widget _buildProductivityTrendsCard() {
    final weekData = [0.4, 0.65, 0.85, 0.5, 0.75, 0.95, 0.6];

    return Container(
      padding: const EdgeInsets.all(kStatCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kStatCardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productivity Trends',
                style: TextStyle(
                  fontSize: kSectionTitleSize,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                  color: const Color(0xFF1A1C1D),
                ),
              ),
              _buildTrendToggle(),
            ],
          ),
          const SizedBox(height: 24), // TODO(UI微调): 标题与图表间距

          // 柱状图
          SizedBox(
            height: kChartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(weekData.length, (index) {
                final isHighest = weekData[index] == weekData.reduce(max);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: kChartBarGap / 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: kChartHeight * weekData[index],
                              decoration: BoxDecoration(
                                color: isHighest ? kPrimaryBlue : const Color(0xFFE8E8EA),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(kChartBarRadius),
                                  topRight: Radius.circular(kChartBarRadius),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF737686),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // 趋势切换按钮
  Widget _buildTrendToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Week', 'Month', 'Year'].map((period) {
          final isSelected = _selectedTrendPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => _selectedTrendPeriod = period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? kPrimaryBlue : const Color(0xFF737686),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Category Breakdown 卡片
  Widget _buildCategoryBreakdownCard() {
    final categories = [
      {'name': 'Work', 'percent': 40, 'color': kPrimaryBlue},
      {'name': 'Personal', 'percent': 25, 'color': kSecondaryOrange},
      {'name': 'Health', 'percent': 15, 'color': const Color(0xFF943700)},
      {'name': 'Study', 'percent': 20, 'color': const Color(0xFFBC4800)},
    ];

    return Container(
      padding: const EdgeInsets.all(kStatCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kStatCardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown',
            style: TextStyle(
              fontSize: kSectionTitleSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'Manrope',
              color: const Color(0xFF1A1C1D),
            ),
          ),
          const SizedBox(height: 24), // TODO(UI微调): 标题与图表间距

          // 环形图
          Center(
            child: SizedBox(
              width: kDonutChartSize,
              height: kDonutChartSize,
              child: CustomPaint(
                painter: _DonutChartPainter(categories),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '248',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope',
                          color: const Color(0xFF1A1C1D),
                        ),
                      ),
                      Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF737686),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32), // TODO(UI微调): 图表与分类列表间距

          // 分类列表
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: categories.map((cat) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: cat['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${cat['name']} (${cat['percent']}%)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 统计卡片组件
// ══════════════════════════════════════════════════════════════
class _StatCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String trendValue;
  final bool trendIsPositive;
  final String label;
  final String value;
  final double? progress;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.trendValue,
    required this.trendIsPositive,
    required this.label,
    required this.value,
    this.progress,
    required this.subtitle,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  /// Safe setState that prevents _debugDuringDeviceUpdate assertion failure
  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(fn);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _safeSetState(() => _isHovered = true),
      onExit: (_) => _safeSetState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _isHovered ? -kStatCardHoverOffset : 0, 0),
        padding: const EdgeInsets.all(kStatCardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kStatCardRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部：图标和趋势
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.iconBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 24,
                    color: widget.iconColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.trendIsPositive
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.trendValue,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.trendIsPositive
                              ? kSuccessGreen
                              : kErrorRed,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        widget.trendIsPositive
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 14,
                        color: widget.trendIsPositive
                            ? kSuccessGreen
                            : kErrorRed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // TODO(UI微调): 图标与标签间距

            // 标签
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: kStatLabelSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF737686),
                letterSpacing: 1, // TODO(UI微调): 标签字间距
              ),
            ),
            const SizedBox(height: 8),

            // 数值
            Text(
              widget.value,
              style: TextStyle(
                fontSize: kStatValueSize,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                color: const Color(0xFF1A1C1D),
                height: 1.1,
              ),
            ),

            // 进度条（如果有）
            if (widget.progress != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(kProgressBarRadius),
                child: LinearProgressIndicator(
                  value: widget.progress,
                  backgroundColor: const Color(0xFFE8E8EA),
                  valueColor: const AlwaysStoppedAnimation<Color>(kSecondaryOrange),
                  minHeight: kProgressBarHeight,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 副标题
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF737686),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 环形图 Painter
// ══════════════════════════════════════════════════════════════
class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;

  _DonutChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.3;
    final innerRadius = radius - strokeWidth;

    double startAngle = -3.14159 / 2; // 从12点钟方向开始

    for (final cat in categories) {
      final sweepAngle = (cat['percent'] as int) / 100 * 2 * 3.14159;
      final paint = Paint()
        ..color = cat['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
