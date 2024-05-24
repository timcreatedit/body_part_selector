import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

/// A workaround to achieve pseudo-infinite scroll with a default Flutter
/// [PageController].
///
/// While scrolling forward is infinite, scrolling backwards is limited to the
/// first page. Thus, the first page is set to [kInfiniteScrollStartPage] to
/// allow for a large number of pages to be scrolled through in either
/// direction.
const int kInfiniteScrollStartPage = 500;

/// A controller for the [RotationStage].
///
/// Wraps a [PageController] and provides a [ValueNotifier] for the current page
/// of the [RotationStage].
class RotationStageController extends ValueNotifier<double> {
  /// Creates a [RotationStageController].
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

  /// The [PageController] instance backing this controller.
  final PageController pageController;

  /// Animates the [RotationStage] to the given page.
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
