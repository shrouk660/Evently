import 'package:evently/core/resources/colors_manager.dart';
import 'package:evently/core/reusable_components/arrow_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/routes_manager.dart';
import '../../../core/resources/string_manager.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../model/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  static const String _onboardingKey = 'onboarding_seen';

  bool get isLast => currentIndex == onboardingModel.length - 1;
  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(RoutesManager.signin);

  }
  void next() {
    if (isLast) {
      _finishOnboarding();
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void back() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: currentIndex > 0
            ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ArrowIcon(
              onClick:back ,
              icon: AssetsManager.arrowLeft
              ),
            )
        : null,
        title: Image.asset(AssetsManager.logo,
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth*0.45,
        ),
        actions: [
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: _finishOnboarding,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                child: Text(
                  StringsManager.skip,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: controller,
                itemCount: onboardingModel.length,
                onPageChanged: (i) => setState(() => currentIndex = i),
                itemBuilder: (context, index) =>
                    Image.asset(onboardingModel[index].image,
                        fit: BoxFit.contain,
                        color: Theme.of(context).colorScheme.onPrimary
                    ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SmoothPageIndicator(
              controller: controller,
              count: onboardingModel.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
                spacing: 6,
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: Theme.of(context).brightness == Brightness.dark
                    ? ColorsManager.whiteColor
                    : ColorsManager.unselectedTabColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        onboardingModel[currentIndex].title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 17
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        onboardingModel[currentIndex].description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              title: isLast ? StringsManager.getStarted :StringsManager.next,
              onClick: next,
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

}
