/// A four-sided stage for representing 3D objects with four widgets
library rotation_stage;

import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

export 'src/model/rotation_stage_side.dart';
export 'src/rotation_stage_bar.dart';
export 'src/rotation_stage_content.dart';
export 'src/rotation_stage_controller.dart';
export 'src/rotation_stage_handle.dart';
export 'src/rotation_stage_labels.dart';

/// The builder function for one side of the [RotationStage].
///
/// Takes the [index] of the side, the [side] itself, and the [currentPage] of
/// the stage. The returned widget should be a representation of the side
/// denoted by [side] and [index].
/// [currentPage] is passed to allow for building custom effects based on the
/// current scroll position, since it can also fall bewtween two pages.
typedef RotationStageBuilder = Widget Function(
  int index,
  RotationStageSide side,
  double currentPage,
);

/// A widget that allows for rotating a widget with four sides in pseudo-3D,
/// with a bar of handles for switching between the sides.
///
/// Combines a [RotationStageContent] with a [RotationStageBar] and optional
/// labels for the sides.
///
/// {@macro rotation_stage_handle.labels}
class RotationStage extends StatefulWidget {
  /// Creates a [RotationStage].
  const RotationStage({
    required this.contentBuilder,
    this.controller,
    this.viewHandleBuilder,
    this.barHeight = 64,
    this.barInteractable = true,
    super.key,
  });

  /// The builder function for the content of the [RotationStage].
  final RotationStageBuilder contentBuilder;

  /// The controller for the [RotationStage].
  ///
  /// If not provided, a new controller will be created and disposed
  /// when the stage is disposed.
  final RotationStageController? controller;

  /// The builder function for the handles of the [RotationStage].
  final RotationStageBuilder? viewHandleBuilder;

  /// The height of the bottom bar in logical pixels.
  final double barHeight;

  /// Whether the bar is interactable at the moment.
  final bool barInteractable;

  @override
  State<RotationStage> createState() => _RotationStageState();
}

class _RotationStageState extends State<RotationStage> {
  late final RotationStageController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? RotationStageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RotationStageContent(
            controller: _controller,
            contentBuilder: widget.contentBuilder,
          ),
        ),
        const Divider(
          height: 1,
        ),
        RotationStageBar(
          controller: _controller,
          interactable: widget.barInteractable,
          viewHandleBuilder: widget.viewHandleBuilder ??
              (index, side, page) => RotationStageHandle(
                    onTap: () => _controller.animateToPage(index),
                    side: side,
                    active: index == page.round(),
                    backgroundTransparent: !widget.barInteractable,
                  ),
        ),
      ],
    );
  }
}
