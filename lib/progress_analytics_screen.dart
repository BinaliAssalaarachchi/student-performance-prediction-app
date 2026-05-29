import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/performance_provider.dart';
import '../models/performance_model.dart';
import 'theme.dart';
import 'dart:math' as math;

class ProgressAnalyticsScreen extends StatefulWidget {
  const ProgressAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<ProgressAnalyticsScreen> createState() => _ProgressAnalyticsScreenState();
}

class _ProgressAnalyticsScreenState extends State<ProgressAnalyticsScreen> {
  // Local state for checkboxes
  final Map<String, bool> _todoList = {
    'Math: Algebra review (2.0 hours)': true,
    'Physics: Mechanics practice (1.5 hours)': false,
    'CS: Python coding lab (1.5 hours)': true,
    'History: Essay preparation (1.0 hours)': false,
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Consumer<PerformanceProvider>(
      builder: (context, provider, _) {
        final history = provider.history;
        
        final double completedCount = _todoList.values.where((v) => v).length.toDouble();
        final double totalCount = _todoList.length.toDouble();
        final double completionRate = totalCount > 0 ? (completedCount / totalCount) : 0.0;

        final lineChartCard = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historical Performance Predictions',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Tracks predicted score outcomes over evaluation history',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CustomPaint(
                  painter: HistoricalTrendPainter(history: history),
                ),
              ),
            ],
          ),
        );

        final taskCompletionCard = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Task Completion Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${(completionRate * 100).toInt()}% Done',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.accentTeal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._todoList.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Checkbox(
                        value: entry.value,
                        activeColor: AppColors.accentTeal,
                        checkColor: AppColors.darkBackground,
                        side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _todoList[entry.key] = val;
                            });
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 13,
                            color: entry.value ? Colors.white54 : Colors.white,
                            decoration: entry.value ? TextDecoration.lineThrough : null,
                            fontWeight: entry.value ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );

        final historyListCard = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Evaluation History Logs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Visual indicators for pass/fail predictions (green for Pass, red for Fail)',
                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
              ),
              const SizedBox(height: 20),
              if (history.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Icon(Icons.analytics_outlined, size: 48, color: Colors.white.withOpacity(0.1)),
                        const SizedBox(height: 12),
                        Text(
                          'No historical evaluation runs recorded yet.',
                          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...history.map((entry) {
                  final isPass = entry.isPass;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C101D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isPass ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPass ? Icons.check_circle_rounded : Icons.error_rounded,
                            color: isPass ? Colors.greenAccent : Colors.redAccent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPass ? 'High Performance (Pass)' : 'Decline Status (Fail)',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${entry.generatedAt.toLocal().toString().split('.').first} · Predicted Score: ${entry.predictedScore ?? 0}%',
                                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          ),
        );

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text(
              'Progress & Analytics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20, 16, 20, isDesktop ? 40 : 110),
            child: isDesktop
                ? Column(
                    children: [
                      lineChartCard,
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: taskCompletionCard),
                          const SizedBox(width: 24),
                          Expanded(flex: 5, child: historyListCard),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      lineChartCard,
                      const SizedBox(height: 24),
                      taskCompletionCard,
                      const SizedBox(height: 24),
                      historyListCard,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// Painter to draw prediction scores over time
class HistoricalTrendPainter extends CustomPainter {
  final List<PerformancePrediction> history;

  HistoricalTrendPainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    const double paddingLeft = 30.0;
    const double paddingBottom = 20.0;
    const double paddingTop = 10.0;
    const double paddingRight = 10.0;

    final double chartWidth = w - paddingLeft - paddingRight;
    final double chartHeight = h - paddingTop - paddingBottom;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0;

    // Y Axis grid lines (0%, 25%, 50%, 75%, 100%)
    for (int i = 0; i <= 4; i++) {
      final double y = paddingTop + chartHeight * (1 - i / 4.0);
      canvas.drawLine(Offset(paddingLeft, y), Offset(w - paddingRight, y), gridPaint);
      _drawText(canvas, Offset(paddingLeft - 26, y - 6), '${i * 25}%', color: AppColors.textSecondary, fontSize: 8);
    }

    // Default mock data if empty
    final points = <Offset>[];
    final scores = history.isNotEmpty
        ? history.reversed.map((e) => (e.predictedScore ?? 50).toDouble()).toList()
        : <double>[45.0, 52.0, 48.0, 65.0, 78.0, 85.0];

    final double stepX = chartWidth / (scores.length > 1 ? (scores.length - 1) : 1);

    for (int i = 0; i < scores.length; i++) {
      final double x = paddingLeft + i * stepX;
      final double y = paddingTop + chartHeight * (1 - scores[i] / 100.0);
      points.add(Offset(x, y));

      // Draw X coordinate marks
      _drawText(canvas, Offset(x - 8, h - paddingBottom + 4), 'R${i + 1}', color: AppColors.textSecondary, fontSize: 8);
    }

    if (points.isNotEmpty) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      // Draw Line path
      final linePaint = Paint()
        ..color = AppColors.accentTeal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, linePaint);

      // Fill Area Gradient
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, paddingTop + chartHeight)
        ..lineTo(points.first.dx, paddingTop + chartHeight)
        ..close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [AppColors.accentTeal.withOpacity(0.12), AppColors.accentTeal.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(paddingLeft, paddingTop, chartWidth, chartHeight))
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);

      // Draw point circles
      final dotPaint = Paint()..color = AppColors.accentTeal;
      final borderPaint = Paint()
        ..color = const Color(0xFF090E1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      for (final pt in points) {
        canvas.drawCircle(pt, 3.5, dotPaint);
        canvas.drawCircle(pt, 3.5, borderPaint);
      }
    }
  }

  void _drawText(Canvas canvas, Offset offset, String text, {Color color = Colors.white, double fontSize = 9}) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
