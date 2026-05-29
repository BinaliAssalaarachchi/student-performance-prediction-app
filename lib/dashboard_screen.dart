import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'performance_analytics_screen.dart';
import 'study_schedule_screen.dart';
import 'progress_analytics_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'providers/performance_provider.dart';
import 'models/performance_model.dart';
import 'models/schedule_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final List<Widget> screens = [
      DashboardHomeScreen(onNavigate: _onNavigate),
      const PerformanceAnalyticsScreen(),
      const StudyScheduleScreen(),
      const ProgressAnalyticsScreen(),
      ProfileScreen(subTabIndex: 0, onSubTabChanged: (_) {}),
      const NotificationsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Row(
        children: [
          // Desktop Left Navigation Sidebar
          if (isDesktop) _buildSidebar(context),
          
          // Main content area
          Expanded(
            child: Stack(
              children: [
                screens[_selectedIndex],
                
                // Mobile Floating Bottom Navigation capsule
                if (!isDesktop)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMobileNavItem(0, Icons.grid_view_rounded),
                          _buildMobileNavItem(1, Icons.analytics_rounded),
                          _buildMobileNavItem(2, Icons.calendar_month_rounded),
                          _buildMobileNavItem(3, Icons.show_chart_rounded),
                          _buildMobileNavItem(4, Icons.person_rounded),
                          _buildMobileNavItem(5, Icons.notifications_rounded),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101D),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.04), width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Name
          Row(
            children: [
              Image.asset(
                'assets/images/logo_processed.png',
                height: 38,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'SmartStudy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Sidebar menu items
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSidebarItem(0, Icons.grid_view_rounded, 'Home Dashboard'),
                const SizedBox(height: 6),
                _buildSidebarItem(1, Icons.analytics_rounded, 'AI Prediction'),
                const SizedBox(height: 6),
                _buildSidebarItem(2, Icons.calendar_month_rounded, 'Schedule Planner'),
                const SizedBox(height: 6),
                _buildSidebarItem(3, Icons.show_chart_rounded, 'Progress & Analytics'),
                const SizedBox(height: 6),
                _buildSidebarItem(4, Icons.person_rounded, 'Student Profile'),
                const SizedBox(height: 6),
                _buildSidebarItem(5, Icons.notifications_rounded, 'Notifications'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavigate(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentTeal.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentTeal.withOpacity(0.18) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accentTeal : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavigate(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF090E1A) : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}

// --- Home Dashboard Screen Widget ---
class DashboardHomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const DashboardHomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  String _getCurrentWeekday() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PerformanceProvider>(context);
    final prediction = provider.prediction;
    final allSchedules = provider.schedules;
    final currentDay = _getCurrentWeekday();

    // Filter today's tasks
    final todayTasks = allSchedules.where((t) => t.day == currentDay).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'SmartStudy Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Hero banner
              _buildWelcomeBanner(),
              const SizedBox(height: 24),

              // Performance Alert Card (green/red indicator)
              _buildPerformanceAlertCard(prediction),
              const SizedBox(height: 24),

              // Today's Smart Schedule Preview
              _buildTodaySchedulePreview(todayTasks),
              const SizedBox(height: 24),

              // Weekly Progress Summary
              _buildWeeklySummary(),
              const SizedBox(height: 28),

              // Quick Action Buttons
              _buildQuickActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back, Alex!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your AI predictive models and daily study schedules are fully optimized for grade maximization.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.4),
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 110,
              child: CustomPaint(
                painter: DashboardBoyPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAlertCard(PerformancePrediction? prediction) {
    final bool hasPrediction = prediction != null;
    final bool isPass = prediction?.isPass ?? true;

    Color alertColor = Colors.orangeAccent;
    IconData alertIcon = Icons.help_outline_rounded;
    String statusTitle = 'No Active Forecast';
    String description = 'Run a performance assessment in AI Prediction to evaluate your Pass/Fail standing.';

    if (hasPrediction) {
      if (isPass) {
        alertColor = Colors.greenAccent;
        alertIcon = Icons.check_circle_rounded;
        statusTitle = 'ACADEMIC STANDING: ON TRACK (PASS)';
        description = 'Great job! The AI model predicts you are in excellent standing for your targets. Keep studying!';
      } else {
        alertColor = Colors.redAccent;
        alertIcon = Icons.error_rounded;
        statusTitle = 'ACADEMIC STANDING: NEEDS ATTENTION (FAIL)';
        description = 'Warning! Predictions suggest your study baseline is at risk. Increase daily study limit immediately.';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: alertColor.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: alertColor.withOpacity(0.04),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(alertIcon, color: alertColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: alertColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.55),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedulePreview(List<ScheduleTask> todayTasks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
                "Today's Smart Schedule Preview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              Text(
                _getCurrentWeekday(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentTeal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (todayTasks.isEmpty) ...[
            Text(
              'No study blocks assigned for today. Head to the Schedule Planner to generate your customized weekly study routine.',
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4), height: 1.5),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => onNavigate(2),
              icon: const Icon(Icons.calendar_month_rounded, size: 16),
              label: const Text('Generate Study Schedule', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentTeal,
                side: const BorderSide(color: AppColors.accentTeal),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ] else
            ...todayTasks.map((task) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C101D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.02)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accentTeal,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        task.subject,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    Text(
                      '${task.hours.toStringAsFixed(1)} hours',
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Progress Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildSummaryItem('Streak', '4 Days', Colors.blueAccent, Icons.bolt_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildSummaryItem('Focus', '82%', Colors.purpleAccent, Icons.psychology_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildSummaryItem('Completed', '3/4 Blocks', Colors.greenAccent, Icons.done_all_rounded)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4)),
              ),
              Icon(icon, color: color, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Action Shortcuts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onNavigate(1),
                icon: const Icon(Icons.analytics_rounded, size: 18),
                label: const Text('Run AI Prediction', style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cardBackground,
                  foregroundColor: AppColors.accentTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.accentTeal.withOpacity(0.2)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onNavigate(2),
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: const Text('Planner & Schedule', style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTeal,
                  foregroundColor: AppColors.darkBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom Painter for boy welcome banner
class DashboardBoyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background glow ring
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.accentTeal.withOpacity(0.1), AppColors.accentTeal.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.5), radius: w * 0.45));
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.45, glow);

    // Torso hoodie
    final torso = Paint()..color = const Color(0xFF2563EB);
    final torsoPath = Path()
      ..moveTo(w * 0.3, h * 0.85)
      ..quadraticBezierTo(w * 0.3, h * 0.55, w * 0.4, h * 0.52)
      ..lineTo(w * 0.6, h * 0.52)
      ..quadraticBezierTo(w * 0.7, h * 0.55, w * 0.7, h * 0.85)
      ..close();
    canvas.drawPath(torsoPath, torso);

    // Head
    final skin = Paint()..color = const Color(0xFFFFD4B2);
    canvas.drawOval(Rect.fromLTWH(w * 0.42, h * 0.3, w * 0.16, h * 0.22), skin);

    // Hair
    final hair = Paint()..color = const Color(0xFF1E293B);
    final hairPath = Path()
      ..moveTo(w * 0.41, h * 0.35)
      ..quadraticBezierTo(w * 0.4, h * 0.25, w * 0.5, h * 0.23)
      ..quadraticBezierTo(w * 0.6, h * 0.25, w * 0.59, h * 0.35)
      ..quadraticBezierTo(w * 0.5, h * 0.3, w * 0.41, h * 0.35)
      ..close();
    canvas.drawPath(hairPath, hair);

    // Book/Laptop on desk
    final device = Paint()..color = const Color(0xFF475569);
    final devicePath = Path()
      ..moveTo(w * 0.25, h * 0.85)
      ..lineTo(w * 0.35, h * 0.7)
      ..lineTo(w * 0.65, h * 0.7)
      ..lineTo(w * 0.75, h * 0.85)
      ..close();
    canvas.drawPath(devicePath, device);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
