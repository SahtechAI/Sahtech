import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/presentation/profile/getstarted.dart';
import 'package:sahtech/core/theme/colors.dart';
import 'package:sahtech/presentation/widgets/custom_button.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  Map<String, String> translations = {
    'skip': 'Skip',
    'title': 'Consulter nutritionniste',
    'subtitle':
        'Vous pouvez contacter des nutritionnistes qui vous guideront pour améliorer votre hygiène de vie.',
    'next': 'Suivant',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            // Responsive dimensions
            double imageWidth = isLandscape ? 0.35.sw : 0.65.sw;
            double imageHeight = isLandscape ? 0.4.sh : 0.3.sh;
            double titleFontSize = isLandscape ? 18.sp : 26.sp;
            double subtitleFontSize = isLandscape ? 12.sp : 16.sp;
            double spacing = isLandscape ? 10.h : 20.h;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing),
                        child: Center(
                          child: Image.asset(
                            'lib/assets/images/onbor3.jpg',
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.contain,
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

                      SizedBox(height: spacing),

                      // Pagination dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _dot(false),
                          SizedBox(width: 8.w),
                          _dot(false),
                          SizedBox(width: 8.w),
                          _dot(true),
                        ],
                      ),

                      const Spacer(),

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
                                        const Getstarted(),
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
            );
          },
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: active ? AppColors.lightTeal : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
