import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/core/utils/models/user_model.dart';
import 'package:sahtech/core/theme/colors.dart';
import 'package:sahtech/core/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class UserSuccess extends StatefulWidget {
  final UserModel userData;

  const UserSuccess({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<UserSuccess> createState() => _UserSuccessState();
}

class _UserSuccessState extends State<UserSuccess> {
  late Map<String, String> _translations;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    setState(() => _isLoading = true);
    _translations = await TranslationService.getTranslations();
    setState(() => _isLoading = false);
  }

  // Navigate to home screen
  void _goToHome() {
    // Reset navigation stack and go to home
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false,
        arguments: widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    Size screenSize = MediaQuery.of(context).size;
    bool isLandscape = screenSize.width > screenSize.height;
    bool isSmallScreen = screenSize.height < 700;

    // Define responsive values based on screen size and orientation
    double iconSize = isLandscape ? 80.w : (isSmallScreen ? 100.w : 120.w);
    double titleFontSize =
        isLandscape ? 20.sp : (isSmallScreen ? 22.sp : 24.sp);
    double subtitleFontSize =
        isLandscape ? 14.sp : (isSmallScreen ? 15.sp : 16.sp);
    double verticalPadding = isLandscape ? 16.h : (isSmallScreen ? 20.h : 24.h);
    double verticalSpacing = isLandscape ? 16.h : (isSmallScreen ? 20.h : 32.h);
    double bottomSpacing = isLandscape ? 24.h : (isSmallScreen ? 30.h : 48.h);
    double buttonPadding = isLandscape ? 12.h : (isSmallScreen ? 14.h : 16.h);
    double buttonFontSize =
        isLandscape ? 14.sp : (isSmallScreen ? 15.sp : 16.sp);
    double topPadding = isLandscape ? 20.h : (isSmallScreen ? 24.h : 30.h);
    double logoHeight =
        isLandscape ? kToolbarHeight * 0.6 : kToolbarHeight * 0.7;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 10.h,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: topPadding),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.lightTeal))
          : Stack(
              children: [
                // Full-screen white background with confetti pattern
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: CustomPaint(
                    painter: ConfettiPainter(),
                  ),
                ),
                // Scrollable content over the confetti background
                SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(verticalPadding),
                      child: Column(
                        children: [
                          // Success icon
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.lightTeal,
                            size: iconSize,
                          ),
                          SizedBox(height: verticalSpacing),

                          // Success message with new text
                          Text(
                            "Votre compte a été créé avec succès",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: verticalPadding),
                          Text(
                            "Merci pour nous faire confiance et partager vous donner avec nous",
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 135.h), // Increased spacing to push button lower (moved ~35px from current place)
                          // Get started button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _goToHome,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightTeal,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: buttonPadding),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              child: Text(
                                "Continuer",
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// Custom painter for confetti pattern
class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final confettiColors = [
      const Color(0xFF9FE870).withOpacity(0.5), // Green
      const Color(0xFFFFC107).withOpacity(0.5), // Yellow
      const Color(0xFFFF9800).withOpacity(0.5), // Orange
      const Color(0xFFE91E63).withOpacity(0.5), // Pink
      const Color(0xFF03A9F4).withOpacity(0.5), // Blue
    ];

    // Draw around 100 confetti pieces
    for (int i = 0; i < 100; i++) {
      final color = confettiColors[random.nextInt(confettiColors.length)];
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // Randomly choose shape: 0=circle, 1=rectangle, 2=line
      final shape = random.nextInt(3);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      switch (shape) {
        case 0: // Circle
          final radius = 2.0 + random.nextDouble() * 6.0;
          canvas.drawCircle(Offset(x, y), radius, paint);
          break;
        case 1: // Rectangle
          final width = 4.0 + random.nextDouble() * 10.0;
          final height = 2.0 + random.nextDouble() * 5.0;
          final angle = random.nextDouble() * pi;

          canvas.save();
          canvas.translate(x, y);
          canvas.rotate(angle);
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: width,
              height: height,
            ),
            paint,
          );
          canvas.restore();
          break;
        case 2: // Line
          final length = 5.0 + random.nextDouble() * 15.0;
          final strokeWidth = 1.0 + random.nextDouble() * 3.0;
          final angle = random.nextDouble() * pi;

          paint.strokeWidth = strokeWidth;

          final dx = cos(angle) * length / 2;
          final dy = sin(angle) * length / 2;

          canvas.drawLine(
            Offset(x - dx, y - dy),
            Offset(x + dx, y + dy),
            paint,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
