import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

/// A bar that displays the handles for the [RotationStage].
class RotationStageBar extends StatelessWidget {
  /// Creates a [RotationStageBar].
  const RotationStageBar({
    required this.controller,
    required this.viewHandleBuilder,
    this.height = kToolbarHeight,
    this.interactable = true,
    this.minHandleOpacity = 0,
    super.key,
  })  : assert(minHandleOpacity >= 0, 'minHandleOpacity must be >= 0'),
        assert(minHandleOpacity <= 1, 'minHandleOpacity must be <= 1');

  /// The controller for the [RotationStage].
  final RotationStageController controller;

  /// The builder function for the handles of the [RotationStage].
  final RotationStageBuilder viewHandleBuilder;

  /// Whether the bar is interactable at the moment.
  final bool interactable;

  /// The height of the bar in logical pixels.
  ///
  /// Defaults to [kToolbarHeight].
  final double height;

  /// The minimum opacity of the handles when they are not visible.
  ///
  /// Must be in the range [0, 1] and defaults to 0.
  final double minHandleOpacity;

  @override
  Widget build(BuildContext context) {
    final visOffset = 0.5 / controller.pageController.viewportFraction;
    return SizedBox(
      height: height,
      child: ValueListenableBuilder<double>(
        valueListenable: controller,
        builder: (context, page, _) => PageView.builder(
          controller: controller.pageController,
          itemBuilder: (context, index) {
            final offset = (page - index).abs().clamp(0, visOffset) / visOffset;
            final opacity = lerpDouble(minHandleOpacity, 1, 1 - offset);
            return Center(
              child: Opacity(
                opacity: Curves.ease.transform(opacity!),
                child: AnimatedOpacity(
                  duration: kThemeAnimationDuration,
                  opacity: interactable && index != index ? 0 : 1,
                  child: viewHandleBuilder(
                    index,
                    RotationStageSide.forIndex(index),
                    page,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
