import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';
import 'package:rotation_stage/src/model/rotation_stage_side.dart';
import 'package:rotation_stage/src/rotation_stage_controller.dart';

class RotationStageContent extends StatelessWidget {
  const RotationStageContent({
    required this.controller,
    required this.contentBuilder,
    super.key,
  });

  final RotationStageController controller;
  final RotationStageBuilder contentBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: controller,
        builder: (context, page, _) {
          final index = page.round();
          final betweenPages = page % 1 > 0;
          return Stack(
            children: [
              for (int i = (betweenPages ? index - 1 : index);
                  i < index + (betweenPages ? 2 : 1);
                  i++)
                IgnorePointer(
                  ignoring: i != index,
                  child: Builder(
                    builder: (context) {
                      final diff = page < 3 || i != 0 ? (i - page) : (4 - page);
                      final opacity = (1 - diff.abs()).clamp(0.0, 1.0);
                      final cMatrix = Matrix4.identity()
                        ..rotateY(-diff * pi / 2)
                        ..setEntry(3, 0, 0.001 * diff);
                      return Opacity(
                        opacity: Curves.easeOutExpo.transform(opacity),
                        child: Transform(
                          transform: cMatrix,
                          alignment: FractionalOffset.center,
                          child: contentBuilder(
                            i,
                            RotationStageSide.forIndex(i),
                            page,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        });
  }
}
