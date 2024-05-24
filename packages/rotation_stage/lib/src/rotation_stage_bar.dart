import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';
import 'package:rotation_stage/src/model/rotation_stage_side.dart';
import 'package:rotation_stage/src/rotation_stage_controller.dart';

class RotationStageBar extends StatelessWidget {
  const RotationStageBar({
    super.key,
    required this.controller,
    required this.viewHandleBuilder,
    this.height = kToolbarHeight,
    this.interactable = true,
    this.minHandleOpacity = 0,
  })  : assert(minHandleOpacity >= 0),
        assert(minHandleOpacity <= 1);

  final RotationStageController controller;
  final RotationStageBuilder viewHandleBuilder;
  final bool interactable;
  final double height;
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
