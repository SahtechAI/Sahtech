import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahtech/core/utils/models/user_model.dart';
import 'package:sahtech/core/utils/models/nutritioniste_model.dart';
import 'package:sahtech/presentation/profile/chronic_disease_screen.dart';
import 'package:sahtech/presentation/nutritionist/Sexe&Specialit%C3%A9_Nutri_screen.dart';
import 'package:sahtech/core/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:sahtech/core/CustomWidgets/language_selector.dart';
import 'package:sahtech/presentation/widgets/custom_button.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen>
    with WidgetsBindingObserver {
  String? selectedUserType;
  late TranslationService _translationService;
  bool _isLoading = true;
  String _currentLanguage = '';

  Map<String, String> _translations = {
    'title': 'Démarrons ensemble',
    'subtitle':
        'Scannez vos aliments et recevez des conseils adaptés à votre profil pour faire les meilleurs choix nutritionnels',
    'normalUserTitle': 'Je suis un utilisateur',
    'normalUserDesc': 'Compte utilisateur pour utiliser l\'appli',
    'nutritionistTitle': 'Je suis un nutritioniste',
    'nutritionistDesc': 'Compte nutritioniste pour être consulter',
    'continue': 'suivant',
    'selectAccountType': 'Veuillez sélectionner un type de compte',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTranslations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final translationService =
        Provider.of<TranslationService>(context, listen: true);

    if (_currentLanguage != translationService.currentLanguageCode) {
      debugPrint(
          "Language changed from $_currentLanguage to ${translationService.currentLanguageCode}");
      _currentLanguage = translationService.currentLanguageCode;
      _loadTranslations();
    }
  }

  Future<void> _loadTranslations() async {
    setState(() => _isLoading = true);

    try {
      _translationService =
          Provider.of<TranslationService>(context, listen: false);

      if (_currentLanguage != 'fr') {
        debugPrint("Translating to $_currentLanguage");
        final translated =
            await _translationService.translateMap(_translations);

        if (mounted) {
          setState(() {
            _translations = translated;
            _isLoading = false;
          });
        }
      } else {
        _translations = {
          'title': 'Démarrons ensemble',
          'subtitle':
              'Scannez vos aliments et recevez des conseils adaptés à votre profil pour faire les meilleurs choix nutritionnels',
          'normalUserTitle': 'Je suis un utilisateur',
          'normalUserDesc': 'Compte utilisateur pour utiliser l\'appli',
          'nutritionistTitle': 'Je suis un nutritioniste',
          'nutritionistDesc': 'Compte nutritioniste pour être consulter',
          'continue': 'suivant',
          'selectAccountType': 'Veuillez sélectionner un type de compte',
        };

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

  void _handleLanguageChanged(String languageCode) {
    debugPrint("Language manually changed to $languageCode");
    setState(() {
      _isLoading = true;
      _currentLanguage = languageCode;
    });

    _loadTranslations();
  }

  void navigateToNextScreen() async {
    if (selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translations['selectAccountType']!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedUserType == 'user') {
      final userData = UserModel(
        userType: selectedUserType!,
        preferredLanguage: _translationService.currentLanguageCode,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChronicDiseaseScreen(userData: userData),
        ),
      );
      return;
    }

    if (selectedUserType == 'nutritionist') {
      final nutritionistData = NutritionisteModel(
        userType: selectedUserType!,
        preferredLanguage: _translationService.currentLanguageCode,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SexespecialiteNutriScreen(nutritionistData: nutritionistData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF9FE870),
          ),
        ),
      );
    }

    // Determine screen dimensions
    Size screenSize = MediaQuery.of(context).size;
    bool isLandscape = screenSize.width > screenSize.height;
    bool isSmallScreen = screenSize.height < 700;
    
    // Define responsive values
    double titleFontSize = isLandscape ? 20.sp : (isSmallScreen ? 22.sp : 24.sp);
    double subtitleFontSize = isLandscape ? 12.sp : (isSmallScreen ? 14.sp : 14.sp);
    double cardPadding = isLandscape ? 12.h : (isSmallScreen ? 14.h : 16.h);
    double spacing = isLandscape ? 12.h : (isSmallScreen ? 16.h : 20.h);
    double bottomSpacing = isLandscape ? 12.h : (isSmallScreen ? 20.h : 24.h);
    double titleSpacing = isLandscape ? 8.h : (isSmallScreen ? 12.h : 12.h);
    double betweenCardsSpacing = isLandscape ? 10.h : (isSmallScreen ? 14.h : 16.h);
    double topPadding = isLandscape ? 16.h : (isSmallScreen ? 20.h : 24.h);
    double logoHeight = isLandscape ? 35.h : (isSmallScreen ? 35.h : 40.h);
    double cardIconSize = isLandscape ? 20.w : (isSmallScreen ? 22.w : 22.w);
    double cardHeight = isLandscape ? 35.w : (isSmallScreen ? 40.w : 40.w);
    double buttonHeight = isLandscape ? 48.h : (isSmallScreen ? 50.h : 54.h);
    double textPadding = isLandscape ? 12.w : (isSmallScreen ? 16.w : 16.w);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPadding),

              // Row for logo and language selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Selector Button on the left
                  LanguageSelectorButton(
                    onLanguageChanged: _handleLanguageChanged,
                  ),

                  // Logo in the center
                  Image.asset(
                    'lib/assets/images/mainlogo.jpg',
                    height: logoHeight,
                    fit: BoxFit.contain,
                  ),

                  // Empty container to balance the row
                  SizedBox(width: 40.w),
                ],
              ),

              SizedBox(height: spacing),

              // Title
              Center(
                child: Text(
                  _translations['title']!,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              SizedBox(height: titleSpacing),

              // Subtitle
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: textPadding),
                  child: Text(
                    _translations['subtitle']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              SizedBox(height: isLandscape ? 20.h : (isSmallScreen ? 25.h : 40.h)),

              // User Selection Card
              InkWell(
                onTap: () {
                  setState(() {
                    selectedUserType = 'user';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: selectedUserType == 'user'
                          ? const Color(0xFF9FE870)
                          : Colors.grey.shade200,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: selectedUserType == 'user'
                            ? const Color(0xFF9FE870).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: cardHeight,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5FFB8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                          size: cardIconSize,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _translations['normalUserTitle']!,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _translations['normalUserDesc']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5FFB8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black87,
                          size: 12.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: betweenCardsSpacing),

              // Nutritionist Selection Card
              InkWell(
                onTap: () {
                  setState(() {
                    selectedUserType = 'nutritionist';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: selectedUserType == 'nutritionist'
                          ? const Color(0xFF9FE870)
                          : Colors.grey.shade200,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: selectedUserType == 'nutritionist'
                            ? const Color(0xFF9FE870).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: cardHeight,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5FFB8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.medical_information_outlined,
                          color: Colors.black87,
                          size: cardIconSize,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _translations['nutritionistTitle']!,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _translations['nutritionistDesc']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5FFB8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black87,
                          size: 12.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // Custom Button for navigation
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: bottomSpacing),
                child: CustomButton(
                  text: _translations['continue']!,
                  onPressed: navigateToNextScreen,
                  width: 1.sw - 48.w,
                  height: buttonHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
