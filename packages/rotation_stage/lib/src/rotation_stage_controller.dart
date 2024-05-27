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
    _addPageControllerListener();
  }

  /// Creates a [RotationStageController] with a custom [PageController].
  ///
  /// This constructor is intended for testing purposes only.
  @visibleForTesting
  RotationStageController.customPageController(this.pageController)
      : super(kInfiniteScrollStartPage.toDouble()) {
    _addPageControllerListener();
    pageController.jumpTo(kInfiniteScrollStartPage.toDouble());
  }

  /// The [PageController] instance backing this controller.
  final PageController pageController;

  void _addPageControllerListener() {
    pageController.addListener(() {
      if (pageController.positions.isNotEmpty && pageController.page != null) {
        value = pageController.page!;
      }
    });
  }

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

  /// Animates the [RotationStage] to the closest page that corresponds to the
  /// given [side].
  void animateToSide(
    RotationStageSide side, {
    Duration duration = kThemeAnimationDuration,
    Curve curve = Curves.ease,
  }) {
    final currentIndex = (value % RotationStageSide.values.length).round();
    final targetIndex = side.index;
    final difference = targetIndex - currentIndex;
    final shortestWay = difference > 2 ? difference - 4 : difference;
    final targetPage = value.round() + shortestWay;
    if (targetPage == value) return;
    animateToPage(
      value.round() + shortestWay,
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
