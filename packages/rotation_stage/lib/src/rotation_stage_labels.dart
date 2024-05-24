import 'package:flutter/widgets.dart';
import 'package:rotation_stage/src/model/rotation_stage_side.dart';

class RotationStageLabelData {
  const RotationStageLabelData({
    required this.front,
    required this.left,
    required this.right,
    required this.back,
  });

  static const english = RotationStageLabelData(
    front: "Front",
    left: "Left",
    right: "Right",
    back: "Back",
  );

  final String front;
  final String left;
  final String right;
  final String back;

  String getForSide(RotationStageSide side) => side.map(
        front: front,
        left: left,
        back: back,
        right: right,
      );
}

class RotationStageLabels extends InheritedWidget {
  const RotationStageLabels({
    super.key,
    required this.data,
    required super.child,
  });

  final RotationStageLabelData data;

  static RotationStageLabelData of(BuildContext context) {
    final RotationStageLabels? result =
        context.dependOnInheritedWidgetOfExactType<RotationStageLabels>();
    return result?.data ?? RotationStageLabelData.english;
  }

  @override
  bool updateShouldNotify(RotationStageLabels oldWidget) {
    return oldWidget.data != data;
  }
}
