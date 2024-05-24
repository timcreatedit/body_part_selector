import 'package:flutter/material.dart';
import 'package:rotation_stage/src/const/scroll_start_page.dart';

class RotationStageController extends ValueNotifier<double> {
  RotationStageController({
    double viewportFraction = 0.2,
  })  : pageController = PageController(
          initialPage: kInfiniteScrollStartPage,
          viewportFraction: viewportFraction,
        ),
        super(kInfiniteScrollStartPage.toDouble()) {
    pageController.addListener(() {
      if (pageController.positions.isNotEmpty && pageController.page != null) {
        value = pageController.page!;
      }
    });
  }

  final PageController pageController;

  void animateToPage(
    int page, {
    Duration duration = kThemeAnimationDuration,
    Curve curve = Curves.ease,
  }) {
    pageController.animateToPage(
      page,
      duration: duration,
      curve: curve,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
