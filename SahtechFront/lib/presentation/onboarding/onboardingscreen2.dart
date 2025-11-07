import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/presentation/profile/getstarted.dart';
import 'onboardingscreen3.dart';
import 'package:sahtech/core/theme/colors.dart';
import 'package:sahtech/core/base/base_screen.dart';
import 'package:sahtech/presentation/widgets/custom_button.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  Map<String, String> translations = {
    'skip': 'Skip',
    'title': 'Suivez votre alimentation',
    'subtitle':
        'Enregistrez vos repas et recevez des recommandations personnalisées pour une alimentation équilibrée.',
    'next': 'Suivant',
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Detect orientation
        bool isLandscape = MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height;

        // Define responsive sizes
        double imageWidth = isLandscape ? 0.4.sw : 0.6.sw;
        double imageHeight = isLandscape ? 0.25.sh : 0.35.sh;
        double titleFontSize = isLandscape ? 20.sp : 28.sp;
        double subtitleFontSize = isLandscape ? 12.sp : 16.sp;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 1.sh),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Skip button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 24.w, top: 16.h),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Getstarted(),
                                ),
                              );
                            },
                            child: Text(
                              translations['skip']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Image
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'lib/assets/images/onbor1.jpg',
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ),
                        ),
                      ),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          translations['title']!,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          translations['subtitle']!,
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Pagination dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: AppColors.lightTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      // Next button
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: CustomButton(
                          text: translations['next']!,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const OnboardingScreen3(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child;
                                },
                                transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          width: 1.sw,
                          height: 56.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
