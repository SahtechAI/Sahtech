import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/core/theme/colors.dart';
import 'package:sahtech/core/utils/models/user_model.dart';
import 'package:sahtech/core/utils/models/nutritioniste_model.dart';
import 'package:sahtech/core/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:sahtech/core/CustomWidgets/language_selector.dart';
import 'package:sahtech/presentation/profile/birthday_screen.dart';
import 'package:sahtech/presentation/widgets/custom_button.dart';

class HeightScreen extends StatefulWidget {
  final UserModel? userData;
  final NutritionisteModel? nutritionistData;
  final int currentStep;
  final int totalSteps;

  const HeightScreen({
    Key? key,
    this.userData,
    this.nutritionistData,
    this.currentStep = 2,
    this.totalSteps = 5,
  })  : assert(userData != null || nutritionistData != null,
            'Either userData or nutritionistData must be provided'),
        super(key: key);

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  late TranslationService _translationService;
  bool _isLoading = false;
  late final String userType;

  // Height related variables
  double _height = 170.0; // Default height in cm
  String _heightUnit = 'cm'; // Default unit

  // Min and max height values
  final double _minHeight = 100.0;
  final double _maxHeight = 200.0;

  // Key translations
  Map<String, String> _translations = {
    'title': 'Veuillez saisir votre taille ?',
    'subtitle':
        'Pour une expérience optimale. Afin de vous offrir un service personnalisé, nous vous invitons à renseigner certaines informations, telles que votre taille',
    'cm': 'cm',
    'inches': 'inches',
    'next': 'suivant',
    'success_message': 'Informations enregistrées avec succès!',
  };

  @override
  void initState() {
    super.initState();
    _translationService =
        Provider.of<TranslationService>(context, listen: false);
    _translationService.addListener(_onLanguageChanged);
    userType = widget.nutritionistData?.userType ??
        widget.userData?.userType ??
        'user';
    _loadTranslations();

    // Initialize height from model data if available
    if (userType == 'nutritionist') {
      // Since NutritionisteModel might not have direct height accessors,
      // we'll use default values or safely check properties
      // This will be initialized with default values
    } else {
      if (widget.userData?.height != null) {
        _height = widget.userData!.height!;
      }
      if (widget.userData?.heightUnit != null) {
        _heightUnit = widget.userData!.heightUnit!;
      }
    }
  }

  @override
  void dispose() {
    _translationService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      _loadTranslations();
    }
  }

  // Load all needed translations
  Future<void> _loadTranslations() async {
    setState(() => _isLoading = true);

    try {
      // Only translate if not French (our default language)
      if (_translationService.currentLanguageCode != 'fr') {
        final translatedStrings =
            await _translationService.translateMap(_translations);

        if (mounted) {
          setState(() {
            _translations = translatedStrings;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('Translation error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Handle language change
  void _handleLanguageChanged(String languageCode) {
    // Update appropriate model with the new language
    if (userType == 'nutritionist') {
      widget.nutritionistData!.preferredLanguage = languageCode;
    } else {
      widget.userData!.preferredLanguage = languageCode;
    }

    // Language change is handled by the listener (_onLanguageChanged)
  }

  // Toggle between cm and inches
  void _toggleUnit(String unit) {
    if (_heightUnit != unit) {
      setState(() {
        _heightUnit = unit;
      });
    }
  }

  // Convert inches to centimeters
  double _inchesToCm(double inches) {
    return inches * 2.54;
  }

  // Convert centimeters to inches
  double _cmToInches(double cm) {
    return cm / 2.54;
  }

  // Format height value for display
  String _formatHeight(double height) {
    if (_heightUnit == 'inches') {
      return _cmToInches(height).toInt().toString();
    }
    return height.toInt().toString();
  }

  void _continueToNextScreen() {
    // Store height value in the appropriate model
    if (userType == 'nutritionist') {
      // We need to manually pass the height data to the next screen
      // as NutritionisteModel doesn't have height/heightUnit fields directly

      // Navigate to the next screen for nutritionist with the existing model
      // and pass height data separately to be handled in the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BirthdayScreen(
            nutritionistData: widget.nutritionistData,
            currentStep: widget.currentStep + 1,
            totalSteps: widget.totalSteps,
          ),
        ),
      );

      // Alternatively, we could store height in another field of NutritionisteModel
      // if needed using custom extension logic
    } else {
      // For regular user
      widget.userData!.height = _height;
      widget.userData!.heightUnit = _heightUnit;

      // Navigate to the next screen for regular user
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BirthdayScreen(
            userData: widget.userData,
            currentStep: widget.currentStep + 1,
            totalSteps: widget.totalSteps,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 45.w,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.only(left: 15.w),
        ),
        title: Image.asset(
          'lib/assets/images/mainlogo.jpg',
          height: kToolbarHeight * 0.6,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          // Language selector button
          LanguageSelectorButton(
            width: 1.sw,
            onLanguageChanged: _handleLanguageChanged,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.lightTeal))
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Get screen dimensions and orientation
                  Size screenSize = MediaQuery.of(context).size;
                  bool isLandscape = screenSize.width > screenSize.height;

                  // Calculate available height for content
                  double availableHeight = constraints.maxHeight;

                  // Adjust sizes based on orientation
                  double cardHeight = isLandscape
                      ? 120.0
                      : 160.0; // Smaller fixed height to prevent overflow
                  double titleFontSize = isLandscape ? 18.sp : 24.sp;
                  double subtitleFontSize = isLandscape ? 12.sp : 14.sp;
                  double spaceBetweenElements = isLandscape ? 10.h : 20.h;
                  double topPadding = isLandscape ? 10.h : 32.h;
                  double textSize = isLandscape ? 40.sp : 70.sp;
                  double buttonHeight = isLandscape ? 40.h : 50.h;

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: availableHeight,
                      ),
                      child: Column(
                        children: [
                          // Progress Bar (70%)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 1.sw * 0.7 - 3.2.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightTeal,
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Main content
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: topPadding),

                                // Main question
                                Text(
                                  _translations['title']!,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                // Subtitle/explanation
                                Text(
                                  _translations['subtitle']!,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),

                                SizedBox(height: spaceBetweenElements),

                                // Height unit selector (cm/inches) - pill style toggle
                                Center(
                                  child: Container(
                                    width: 120.w,
                                    height:
                                        30.h, // Smaller height to save space
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      children: [
                                        // inches selector
                                        GestureDetector(
                                          onTap: () => _toggleUnit('inches'),
                                          child: Container(
                                            width: 60.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: _heightUnit == 'inches'
                                                  ? Colors.white
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              boxShadow: _heightUnit == 'inches'
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 2,
                                                        spreadRadius: 0.5,
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'in',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // cm selector
                                        GestureDetector(
                                          onTap: () => _toggleUnit('cm'),
                                          child: Container(
                                            width: 60.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: _heightUnit == 'cm'
                                                  ? AppColors.lightTeal
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'cm',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: spaceBetweenElements),

                                // Height display area with slider - no fixed height
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF9E8),
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Height value display
                                      Container(
                                        width: 0.4.sw,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            _formatHeight(_height),
                                            style: TextStyle(
                                              fontSize: textSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: spaceBetweenElements),

                                      // Scale markings and slider
                                      Container(
                                        width: 0.7.sw,
                                        child: Column(
                                          children: [
                                            // Scale markings
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _heightUnit == 'cm'
                                                      ? '100'
                                                      : '39',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  _heightUnit == 'cm'
                                                      ? '125'
                                                      : '49',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  _heightUnit == 'cm'
                                                      ? '150'
                                                      : '59',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  _heightUnit == 'cm'
                                                      ? '175'
                                                      : '69',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  _heightUnit == 'cm'
                                                      ? '200'
                                                      : '79',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Scale ticks
                                            Container(
                                              width: 0.9.sw,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: List.generate(
                                                  41,
                                                  (index) => Container(
                                                    height: index % 10 == 0
                                                        ? 8.h
                                                        : 4.h,
                                                    width: 1.w,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Slider
                                            SliderTheme(
                                              data: SliderThemeData(
                                                activeTrackColor:
                                                    Colors.transparent,
                                                inactiveTrackColor:
                                                    Colors.transparent,
                                                thumbColor: Colors.black,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                  enabledThumbRadius: 4.r,
                                                ),
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                  overlayRadius: 8.r,
                                                ),
                                                trackHeight: 0,
                                              ),
                                              child: Slider(
                                                value:
                                                    _height.clamp(100.0, 200.0),
                                                min: 100.0,
                                                max: 200.0,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _height = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Height unit
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Text(
                                          _heightUnit,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 90.h),

                                // Next button - always appears after the slider
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: CustomButton(
                                    text: _translations['next']!,
                                    onPressed: _continueToNextScreen,
                                    width: 1.sw - 40.w,
                                    height: buttonHeight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
