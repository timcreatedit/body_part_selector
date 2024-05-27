import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rotation_stage/rotation_stage.dart';

class _MockPageController extends Mock implements PageController {}

void main() {
  group('RotationStageController', () {
    late _MockPageController pageController;
    late RotationStageController sut;

    setUp(() {
      pageController = _MockPageController();
      registerFallbackValue(Duration.zero);
      registerFallbackValue(Curves.linear);
      when(
        () => pageController.animateToPage(
          any(),
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        ),
      ).thenAnswer((_) async {});
      sut = RotationStageController.customPageController(pageController);
    });

    group('animateToPage', () {
      test('calls animateToPage on pageController with default values', () {
        sut.animateToPage(1);
        verify(
          () => pageController.animateToPage(
            1,
            duration: kThemeAnimationDuration,
            curve: Curves.ease,
          ),
        );
      });

      test('forwards parameters', () async {
        sut.animateToPage(
          1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        verify(
          () => pageController.animateToPage(
            1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          ),
        );
      });
    });

    group('animateToSide', () {
      void verifyAnimateToPageCalledWith(int page) {
        verify(
          () => pageController.animateToPage(
            page,
            duration: kThemeAnimationDuration,
            curve: Curves.ease,
          ),
        );
      }

      test('calls animateToPage correctly for left', () {
        sut.animateToSide(RotationStageSide.left);
        verifyAnimateToPageCalledWith(kInfiniteScrollStartPage + 1);
      });

      test('calls animateToPage correctly for back', () {
        sut.animateToSide(RotationStageSide.back);
        verifyAnimateToPageCalledWith(kInfiniteScrollStartPage + 2);
      });

      test('calls animateToPage correctly for right', () {
        sut.animateToSide(RotationStageSide.right);
        verifyAnimateToPageCalledWith(kInfiniteScrollStartPage - 1);
      });

      test('does not call animate to page for current side', () {
        sut.animateToSide(RotationStageSide.front);
        verifyNever(
          () => pageController.animateToPage(
            any(),
            duration: any(named: 'duration'),
            curve: any(named: 'curve'),
          ),
        );
      });
    });
  });
}
