import 'package:flutter/widgets.dart';
import 'package:rotation_stage/rotation_stage.dart';

/// Holds the labels for each [RotationStageSide].
class RotationStageLabelData {
  /// Creates a [RotationStageLabelData].
  const RotationStageLabelData({
    required this.front,
    required this.left,
    required this.right,
    required this.back,
  });

  /// The default English labels for the sides of the [RotationStage].
  static const english = RotationStageLabelData(
    front: "Front",
    left: "Left",
    right: "Right",
    back: "Back",
  );

  /// The label for the front side.
  final String front;

  /// The label for the left side.
  final String left;

  /// The label for the right side.
  final String right;

  /// The label for the back side.
  final String back;

  /// Returns the label for the given [side].
  String getForSide(RotationStageSide side) => side.map(
        front: front,
        left: left,
        back: back,
        right: right,
      );
}

/// An [InheritedWidget] that holds the [RotationStageLabelData] for the
/// [RotationStage] and provides them to the widgets below it in the widget
/// tree.
class RotationStageLabels extends InheritedWidget {
  /// Creates a [RotationStageLabels].
  const RotationStageLabels({
    required this.data,
    required super.child,
    super.key,
  });

  /// The data for the labels.
  final RotationStageLabelData data;

  /// Returns the [RotationStageLabelData] for the [RotationStage] from the
  /// [context], or falls back to [RotationStageLabelData.english], if none
  /// are found.
  static RotationStageLabelData of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<RotationStageLabels>();
    return result?.data ?? RotationStageLabelData.english;
  }

  @override
  bool updateShouldNotify(RotationStageLabels oldWidget) {
    return oldWidget.data != data;
  }
}
