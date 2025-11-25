import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/presentation/profile/choice_screen.dart';
import 'package:sahtech/core/theme/colors.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    Size screenSize = MediaQuery.of(context).size;
    bool isLandscape = screenSize.width > screenSize.height;
    bool isSmallScreen = screenSize.height < 700;
    
    // Define sizes based on orientation and screen size
    double logoHeight = isLandscape ? 30.h : (isSmallScreen ? 35.h : 40.h);
    double imageWidth = isLandscape ? 0.5.sw : (isSmallScreen ? 0.6.sw : 0.7.sw);
    double imageHeight = isLandscape ? 0.25.sh : (isSmallScreen ? 0.3.sh : 0.4.sh);
    double titleFontSize = isLandscape ? 20.sp : (isSmallScreen ? 22.sp : 24.sp);
    double subtitleFontSize = isLandscape ? 14.sp : (isSmallScreen ? 15.sp : 16.sp);
    double verticalPadding = isLandscape ? 15.h : (isSmallScreen ? 20.h : 24.h);
    double buttonPadding = isLandscape ? 12.h : (isSmallScreen ? 14.h : 16.h);
    double spacing = isLandscape ? 8.h : (isSmallScreen ? 12.h : 16.h);
    double bottomSpacing = isLandscape ? 15.h : (isSmallScreen ? 18.h : 24.h);
    
    return Scaffold(
      backgroundColor: Colors.white, // Ensure the entire screen has a white background
      body: SingleChildScrollView(  // Add SingleChildScrollView to prevent overflow
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height,
          ),
          child: Column(
            children: [
              // Top section with green background, logo and illustration
              Container(
                width: double.infinity,
                height: isLandscape 
                  ? 0.55 * screenSize.height 
                  : (screenSize.height < 700 ? 0.65 * screenSize.height : 0.7 * screenSize.height), // Use adaptive height based on screen
                decoration: BoxDecoration(
                  color: const Color(0xFF9FE870).withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Logo at the top
                      Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: Image.asset(
                          'lib/assets/images/mainlogo.jpg',
                          height: logoHeight,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Area for the main illustration
                      Flexible(  // Use Flexible instead of Expanded to allow shrinking
                        flex: 2,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'lib/assets/images/getstarted2.jpg',
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section with white background, text and button
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: verticalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title text
                    Text(
                      'Votre santé est notre priorité',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: spacing),

                    // Subtitle text
                    Text(
                      'Soyez plus saine avec notre application sahtech',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: bottomSpacing),

                    // Get Started button
                    Container(
                      width: double.infinity,
                      height: 56.h, // Fixed height for consistency across devices
                      margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChoiceScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9FE870),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Get started',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
