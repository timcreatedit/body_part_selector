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

typedef RotationStageBuilder = Widget Function(
  int index,
  RotationStageSide side,
  double currentPage,
);

class RotationStage extends StatefulWidget {
  const RotationStage({
    super.key,
    required this.contentBuilder,
    this.controller,
    this.viewHandleBuilder,
    this.labels,
    this.barHeight = 64,
    this.barInteractable = true,
  });

  final RotationStageBuilder contentBuilder;
  final RotationStageController? controller;
  final RotationStageBuilder? viewHandleBuilder;
  final RotationStageLabelData? labels;
  final double barHeight;
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
    return RotationStageLabels(
      data: widget.labels ?? RotationStageLabelData.english,
      child: Column(
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
      ),
    );
  }
}
