import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // 1. Soft Neon Decorative Background Glows
          Positioned(
            top: -120,
            right: -120,
            width: 380,
            height: 380,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentTeal.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            left: -150,
            top: 220,
            width: 450,
            height: 450,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2563EB).withOpacity(0.08),
              ),
            ),
          ),
          
          // Background Dot Grids (matching the dark layout texture)
          Positioned(
            top: 140,
            right: 40,
            child: DotGrid(width: 80, height: 100, color: AppColors.accentTeal.withOpacity(0.05)),
          ),
          Positioned(
            bottom: 220,
            left: 30,
            child: DotGrid(width: 60, height: 80, color: const Color(0xFF2563EB).withOpacity(0.05)),
          ),

          // 2. Main Scrollable Content Area
          SafeArea(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1100 : 540,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 48 : 24,
                    vertical: isDesktop ? 40 : 16,
                  ),
                  child: isDesktop
                      ? _buildDesktopLayout(context)
                      : _buildMobileLayout(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Layout Builders ---

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        _buildBrandHeader(isDesktop: false),
        const SizedBox(height: 24),
        _buildHeroTitle(isDesktop: false),
        const SizedBox(height: 12),
        _buildSubtitle(isDesktop: false),
        const SizedBox(height: 24),
        const StudyIllustration(),
        const SizedBox(height: 28),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFeatureCard(
                Icons.insights_rounded,
                'Performance\nPrediction',
                'Predict future\nacademic performance',
                false,
              ),
              _buildFeatureCard(
                Icons.edit_calendar_rounded,
                'Smart Study\nSchedule',
                'Personalized\nstudy planning',
                false,
              ),
              _buildFeatureCard(
                Icons.pie_chart_rounded,
                'Progress\nTracking',
                'Track learning\nimprovement',
                false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildActionButtons(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Branding, Hero Header, Subtitles, Buttons
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBrandHeader(isDesktop: true),
              const SizedBox(height: 36),
              _buildHeroTitle(isDesktop: true),
              const SizedBox(height: 16),
              _buildSubtitle(isDesktop: true),
              const SizedBox(height: 48),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: _buildActionButtons(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: 64),
        // Right Column: Illustration & Feature Cards
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StudyIllustration(),
              const SizedBox(height: 36),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFeatureCard(
                      Icons.insights_rounded,
                      'Performance\nPrediction',
                      'Predict future\nacademic performance',
                      true,
                    ),
                    _buildFeatureCard(
                      Icons.edit_calendar_rounded,
                      'Smart Study\nSchedule',
                      'Personalized\nstudy planning',
                      true,
                    ),
                    _buildFeatureCard(
                      Icons.pie_chart_rounded,
                      'Progress\nTracking',
                      'Track learning\nimprovement',
                      true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Sub-widgets & UI Helpers ---

  Widget _buildBrandHeader({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_processed.png',
          height: isDesktop ? 96 : 84,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          'SmartStudy',
          style: TextStyle(
            fontSize: isDesktop ? 28 : 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Smart planning for smart results.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.accentTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroTitle({required bool isDesktop}) {
    return RichText(
      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: isDesktop ? 44 : 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.25,
          fontFamily: 'Inter',
        ),
        children: const [
          TextSpan(text: 'Predict. '),
          TextSpan(
            text: 'Plan.',
            style: TextStyle(color: AppColors.accentTeal),
          ),
          TextSpan(text: ' Succeed.'),
        ],
      ),
    );
  }

  Widget _buildSubtitle({required bool isDesktop}) {
    return Text(
      'AI-powered student performance prediction and personalized study schedules to help students improve academically.',
      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
      style: TextStyle(
        fontSize: isDesktop ? 15 : 13,
        color: AppColors.textSecondary,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String subtitle,
    bool isDesktop,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 4),
        padding: EdgeInsets.all(isDesktop ? 16 : 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: isDesktop ? 48 : 38,
              height: isDesktop ? 48 : 38,
              decoration: BoxDecoration(
                color: AppColors.accentTeal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.accentTeal,
                size: isDesktop ? 22 : 18,
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 12 : 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 10 : 8,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Register Button (Filled Neon Teal with dark blue text)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentTeal,
              foregroundColor: AppColors.darkBackground,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: Icon(Icons.arrow_forward_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Login Button (Outlined Neon Teal)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentTeal,
              side: const BorderSide(color: AppColors.accentTeal, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: Icon(Icons.arrow_forward_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Security Badge
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_rounded,
              color: AppColors.accentTeal,
              size: 14,
            ),
            SizedBox(width: 6),
            Text(
              'Your data is safe with us.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Background Pattern Painters ---

class DotGridPainter extends CustomPainter {
  final Color color;
  const DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const double spacing = 12.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DotGrid extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const DotGrid({Key? key, required this.width, required this.height, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: DotGridPainter(color: color),
      ),
    );
  }
}

// --- Custom Workspace Vector Illustration Widget ---

class StudyIllustration extends StatelessWidget {
  const StudyIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35, // Width to height ratio
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final scale = w / 400.0; // scale factor based on reference width 400

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Base Painted Workspace Elements (Desk, boy, accessories)
              Positioned.fill(
                child: CustomPaint(
                  painter: WorkspacePainter(),
                ),
              ),

              // 2. Floating Card 1: Performance Prediction (Top Left)
              Positioned(
                top: h * 0.08,
                left: w * 0.04,
                width: w * 0.38,
                child: _buildPredictCard(scale),
              ),

              // 3. Floating Card 2: Study Plan (Top Right)
              Positioned(
                top: h * 0.05,
                right: w * 0.04,
                width: w * 0.34,
                child: _buildPlanCard(scale),
              ),

              // 4. Floating Card 3: Progress Pie Chart (Middle Right)
              Positioned(
                top: h * 0.52,
                right: w * 0.06,
                width: w * 0.28,
                child: _buildProgressCard(scale),
              ),
            ],
          );
        },
      ),
    );
  }

  // Floating card builders:

  Widget _buildPredictCard(double scale) {
    return Container(
      padding: EdgeInsets.all(8 * scale),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.2 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Performance Prediction',
                  style: TextStyle(
                    fontSize: 8 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2 * scale,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 2 * scale),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal,
                  borderRadius: BorderRadius.circular(6 * scale),
                ),
                child: Text(
                  '85%',
                  style: TextStyle(
                    fontSize: 7 * scale,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkBackground,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6 * scale),
          SizedBox(
            height: 35 * scale,
            width: double.infinity,
            child: CustomPaint(
              painter: const MiniGraphPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(double scale) {
    return Container(
      padding: EdgeInsets.all(8 * scale),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.2 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Study Plan',
            style: TextStyle(
              fontSize: 8 * scale,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6 * scale),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3 * scale,
            crossAxisSpacing: 3 * scale,
            childAspectRatio: 1.3,
            children: List.generate(8, (index) {
              final checked = index == 1 || index == 3 || index == 4 || index == 6;
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(3 * scale),
                ),
                child: checked
                    ? Icon(Icons.check_rounded, color: AppColors.accentTeal, size: 10 * scale)
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double scale) {
    return Container(
      padding: EdgeInsets.all(6 * scale),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.2 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22 * scale,
            height: 22 * scale,
            child: CustomPaint(
              painter: const MiniPieChartPainter(),
            ),
          ),
          SizedBox(width: 6 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28 * scale,
                  height: 4 * scale,
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal,
                    borderRadius: BorderRadius.circular(2 * scale),
                  ),
                ),
                SizedBox(height: 3 * scale),
                Container(
                  width: 16 * scale,
                  height: 4 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2 * scale),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Painters for floating elements:

class MiniGraphPainter extends CustomPainter {
  const MiniGraphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.accentTeal.withOpacity(0.18), AppColors.accentTeal.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.65, size.width * 0.6, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.45, size.width, size.height * 0.1);

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    final dotPaint = Paint()..color = AppColors.accentTeal;
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniPieChartPainter extends CustomPainter {
  const MiniPieChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.5, paint);

    final slicePaint = Paint()
      ..color = AppColors.accentTeal
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -1.57, // start at top (90 deg)
      4.1,   // sweep angle (around 260 degrees)
      true,
      slicePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Main Workspace Vector Scene Painter
class WorkspacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Glowing base background circular aura behind boy
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentTeal.withOpacity(0.08),
          AppColors.accentTeal.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.5), radius: w * 0.42));
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.42, glowPaint);

    // Desk surface Top (curved, soft dark blue/slate shape)
    final deskPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, h * 0.72, w, h * 0.28));
    
    final deskPath = Path()
      ..moveTo(0, h * 0.74)
      ..quadraticBezierTo(w * 0.5, h * 0.67, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(deskPath, deskPaint);

    // Desk edge depth line
    final deskEdgePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.74)
        ..quadraticBezierTo(w * 0.5, h * 0.67, w, h * 0.74),
      deskEdgePaint,
    );

    // Torso / Blue hoodie of the boy studying (proportional ratios)
    final hoodiePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(w * 0.32, h * 0.43, w * 0.36, h * 0.31));
    
    final hoodiePath = Path()
      ..moveTo(w * 0.32, h * 0.74)
      ..quadraticBezierTo(w * 0.32, h * 0.45, w * 0.43, h * 0.43) // left shoulder
      ..lineTo(w * 0.57, h * 0.43) // shoulder/neck line
      ..quadraticBezierTo(w * 0.68, h * 0.45, w * 0.68, h * 0.74) // right shoulder
      ..close();
    canvas.drawPath(hoodiePath, hoodiePaint);

    // Hood details
    final hoodInnerPaint = Paint()..color = const Color(0xFF1E40AF);
    canvas.drawOval(Rect.fromLTWH(w * 0.43, h * 0.42, w * 0.14, h * 0.06), hoodInnerPaint);

    // Neck
    final neckPaint = Paint()..color = const Color(0xFFFFD4B2);
    canvas.drawRect(Rect.fromLTWH(w * 0.47, h * 0.36, w * 0.06, h * 0.08), neckPaint);

    // Head/Face (Proportional Oval - Height > Width)
    canvas.drawOval(Rect.fromLTWH(w * 0.45, h * 0.24, w * 0.10, h * 0.18), neckPaint);

    // Face features (adjusted for new head dimensions)
    final faceFeaturesPaint = Paint()
      ..color = const Color(0xFF9A3412).withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    
    // Left eye curve
    canvas.drawArc(Rect.fromLTWH(w * 0.47, h * 0.29, w * 0.015, h * 0.015), 0.2, 2.7, false, faceFeaturesPaint);
    // Right eye curve
    canvas.drawArc(Rect.fromLTWH(w * 0.515, h * 0.29, w * 0.015, h * 0.015), 0.2, 2.7, false, faceFeaturesPaint);
    // Mouth curve
    canvas.drawArc(Rect.fromLTWH(w * 0.485, h * 0.33, w * 0.03, h * 0.02), 0.1, 2.9, false, faceFeaturesPaint);

    // Hair (Upright sweep matching the head)
    final hairPaint = Paint()..color = const Color(0xFF1E293B);
    final hairPath = Path()
      ..moveTo(w * 0.445, h * 0.28)
      ..quadraticBezierTo(w * 0.43, h * 0.20, w * 0.50, h * 0.19) // top sweep
      ..quadraticBezierTo(w * 0.57, h * 0.20, w * 0.555, h * 0.28) // right side
      ..quadraticBezierTo(w * 0.50, h * 0.24, w * 0.445, h * 0.28) // hairline
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // Arms/Hands (Leaning on book, connected to shoulders)
    final armPaint = Paint()..color = const Color(0xFF3B82F6);
    
    // Left arm resting
    final leftArm = Path()
      ..moveTo(w * 0.33, h * 0.74)
      ..quadraticBezierTo(w * 0.37, h * 0.69, w * 0.44, h * 0.73)
      ..lineTo(w * 0.42, h * 0.77)
      ..close();
    canvas.drawPath(leftArm, armPaint);

    // Right arm writing
    final rightArm = Path()
      ..moveTo(w * 0.67, h * 0.74)
      ..quadraticBezierTo(w * 0.63, h * 0.67, w * 0.54, h * 0.72)
      ..lineTo(w * 0.55, h * 0.76)
      ..close();
    canvas.drawPath(rightArm, armPaint);

    // Writing hand
    canvas.drawCircle(Offset(w * 0.525, h * 0.72), w * 0.018, neckPaint);

    // Pen
    final penPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 1.8;
    canvas.drawLine(Offset(w * 0.525, h * 0.72), Offset(w * 0.505, h * 0.68), penPaint);

    // Open notebook (book sheets layout)
    final bookPaint = Paint()..color = Colors.white;
    final bookBorder = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final bookPath = Path()
      ..moveTo(w * 0.39, h * 0.73)
      ..lineTo(w * 0.49, h * 0.705)
      ..lineTo(w * 0.59, h * 0.73)
      ..lineTo(w * 0.57, h * 0.80)
      ..lineTo(w * 0.49, h * 0.775)
      ..lineTo(w * 0.41, h * 0.80)
      ..close();
    canvas.drawPath(bookPath, bookPaint);
    canvas.drawPath(bookPath, bookBorder);
    
    // Page fold line
    canvas.drawLine(Offset(w * 0.49, h * 0.705), Offset(w * 0.49, h * 0.775), bookBorder);

    // Laptop on the right (dark slate panel side profile)
    final laptopPaint = Paint()..color = const Color(0xFF475569);
    final screenBackPaint = Paint()..color = const Color(0xFF1E293B);
    final glowOverlayPaint = Paint()
      ..color = AppColors.accentTeal.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    // Outer screen lid
    final lidPath = Path()
      ..moveTo(w * 0.61, h * 0.69)
      ..lineTo(w * 0.75, h * 0.54)
      ..lineTo(w * 0.77, h * 0.55)
      ..lineTo(w * 0.63, h * 0.71)
      ..close();
    canvas.drawPath(lidPath, laptopPaint);

    // Glowing Screen panel
    final screenPath = Path()
      ..moveTo(w * 0.62, h * 0.70)
      ..lineTo(w * 0.74, h * 0.55)
      ..lineTo(w * 0.76, h * 0.56)
      ..lineTo(w * 0.64, h * 0.71)
      ..close();
    canvas.drawPath(screenPath, screenBackPaint);
    canvas.drawPath(screenPath, glowOverlayPaint);

    // Keyboard Base
    final baseKeyboardPath = Path()
      ..moveTo(w * 0.63, h * 0.71)
      ..lineTo(w * 0.77, h * 0.55)
      ..lineTo(w * 0.84, h * 0.72)
      ..lineTo(w * 0.66, h * 0.74)
      ..close();
    canvas.drawPath(baseKeyboardPath, laptopPaint);

    // Coffee mug next to laptop
    final mugPaint = Paint()..color = AppColors.accentTeal;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.81, h * 0.705, w * 0.045, h * 0.055), const Radius.circular(2)), mugPaint);
    
    // Handle
    final handlePaint = Paint()
      ..color = AppColors.accentTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawArc(Rect.fromLTWH(w * 0.84, h * 0.72, w * 0.025, h * 0.025), -1.5, 3.0, false, handlePaint);

    // Stack of books (left side)
    final book1Paint = Paint()..color = const Color(0xFF2563EB);
    final book2Paint = Paint()..color = AppColors.accentTeal;
    final pagesPaint = Paint()..color = Colors.white;

    // Bottom book
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.13, h * 0.69, w * 0.15, h * 0.04), const Radius.circular(2)), book1Paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.70, w * 0.03, h * 0.02), pagesPaint);

    // Top book
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.65, w * 0.14, h * 0.04), const Radius.circular(2)), book2Paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.26, h * 0.66, w * 0.03, h * 0.02), pagesPaint);

    // Potted plant (far left)
    final potPaint = Paint()..color = const Color(0xFF475569);
    final leafPaint = Paint()..color = const Color(0xFF10B981);
    
    // Pot
    final potPath = Path()
      ..moveTo(w * 0.07, h * 0.67)
      ..lineTo(w * 0.11, h * 0.67)
      ..lineTo(w * 0.10, h * 0.73)
      ..lineTo(w * 0.08, h * 0.73)
      ..close();
    canvas.drawPath(potPath, potPaint);

    // Plant leaves
    canvas.drawOval(Rect.fromLTWH(w * 0.05, h * 0.59, w * 0.04, h * 0.08), leafPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.09, h * 0.57, w * 0.04, h * 0.09), leafPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.07, h * 0.55, w * 0.04, h * 0.10), leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
