import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/Entities/OnBoardingModel.dart';
import 'package:my_party/src/features/screens/on_boarding/on_boarding_page_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide() {
    print("ok");
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }

  getPages(context) {
    return [
      OnBoardingPage(
          model: OnBoardingModel(
              image: onBoardImage1,
              title: AppLocalizations.of(context)!.onBoarding1Title,
              subtitle: AppLocalizations.of(context)!.onBoarding1SubTitle,
              bgColor: onBoardColor1
          )
      ),
      OnBoardingPage(
          model: OnBoardingModel(
            image: onBoardImage2,
            title: AppLocalizations.of(context)!.onBoarding2Title,
            subtitle: AppLocalizations.of(context)!.onBoarding2SubTitle,
            bgColor: onBoardColor2,
          )
      ),
      OnBoardingPage(
          model: OnBoardingModel(
            image: onBoardImage3,
            title: AppLocalizations.of(context)!.onBoarding3Title,
            subtitle: AppLocalizations.of(context)!.onBoarding3SubTitle,
            bgColor: onBoardColor3,
          )
      )
    ];
  }


}