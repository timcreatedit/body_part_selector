import 'package:rotation_stage/rotation_stage.dart';

/// Represents one of the four sides of the [RotationStage].
///
/// Values are ordered as if rotating the stage from left to right when looking
/// at it from the front.
enum RotationStageSide {
  /// The front side of the [RotationStage].
  front,

  /// The left side of the [RotationStage].
  left,

  /// The back side of the [RotationStage].
  back,

  /// The right side of the [RotationStage].
  right;

  /// Returns the [RotationStageSide] for the given index.
  ///
  /// The index is wrapped around the number of values in the enum, and the
  /// order is the same as the order of the values in the enum.
  static RotationStageSide forIndex(int i) => values[i % values.length];

  /// Maps the side to a value of type [T].
  T map<T>({
    required T front,
    required T left,
    required T back,
    required T right,
  }) {
    return switch (this) {
      RotationStageSide.front => front,
      RotationStageSide.left => left,
      RotationStageSide.back => back,
      RotationStageSide.right => right,
    };
  }
}
