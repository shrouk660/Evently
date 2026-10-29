import '../core/resources/assets_manager.dart';
import '../../../core/resources/string_manager.dart';
class OnboardingModel {
  final String image;
  final String title;
  final String description;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.description
  });
}
 List<OnboardingModel> onboardingModel =[
  OnboardingModel(
    image: AssetsManager.onboarding1,
    title: StringsManager.titleOnboarding1,
    description: StringsManager.descriptionOnboarding1,
  ),
  OnboardingModel(
      image: AssetsManager.onboarding2,
      title: StringsManager.titleOnboarding2,
      description: StringsManager.descriptionOnboarding2
  ),
  OnboardingModel(
      image: AssetsManager.onboarding3,
      title: StringsManager.titleOnboarding3,
      description: StringsManager.descriptionOnboarding3
  ),

];