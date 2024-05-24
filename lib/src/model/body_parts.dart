import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_parts.freezed.dart';
part 'body_parts.g.dart';

/// A class representing the different parts of the body that can be selected,
/// and whether they are.
@freezed
class BodyParts with _$BodyParts {
  /// Creates a new [BodyParts] object.
  const factory BodyParts({
    @Default(false) bool head,
    @Default(false) bool neck,
    @Default(false) bool leftShoulder,
    @Default(false) bool leftUpperArm,
    @Default(false) bool leftElbow,
    @Default(false) bool leftLowerArm,
    @Default(false) bool leftHand,
    @Default(false) bool rightShoulder,
    @Default(false) bool rightUpperArm,
    @Default(false) bool rightElbow,
    @Default(false) bool rightLowerArm,
    @Default(false) bool rightHand,
    @Default(false) bool upperBody,
    @Default(false) bool lowerBody,
    @Default(false) bool leftUpperLeg,
    @Default(false) bool leftKnee,
    @Default(false) bool leftLowerLeg,
    @Default(false) bool leftFoot,
    @Default(false) bool rightUpperLeg,
    @Default(false) bool rightKnee,
    @Default(false) bool rightLowerLeg,
    @Default(false) bool rightFoot,
    @Default(false) bool abdomen,
    @Default(false) bool vestibular,
  }) = _BodyParts;

  /// Creates a new [BodyParts] object from a JSON object.
  factory BodyParts.fromJson(Map<String, dynamic> json) =>
      _$BodyPartsFromJson(json);
  const BodyParts._();

  /// A constant representing a selection with all [BodyParts] selected.
  static const all = BodyParts(
    head: true,
    neck: true,
    leftShoulder: true,
    leftUpperArm: true,
    leftElbow: true,
    leftLowerArm: true,
    leftHand: true,
    rightShoulder: true,
    rightUpperArm: true,
    rightElbow: true,
    rightLowerArm: true,
    rightHand: true,
    upperBody: true,
    lowerBody: true,
    leftUpperLeg: true,
    leftKnee: true,
    leftLowerLeg: true,
    leftFoot: true,
    rightUpperLeg: true,
    rightKnee: true,
    rightLowerLeg: true,
    rightFoot: true,
    abdomen: true,
    vestibular: true,
  );

  /// Toggles the BodyPart with the given [id].
  ///
  /// If [id] doesn't represent a valid BodyPart, this returns an unchanged
  /// Object. If [mirror] is true, and the BodyPart is one that exists on both
  /// sides (e.g. Knee), the other side is toggled as well.
  BodyParts withToggledId(String id, {bool mirror = false}) {
    final map = toMap();
    if (!map.containsKey(id)) return this;
    map[id] = !(map[id] ?? false);
    if (mirror) {
      if (id.contains("left")) {
        final mirroredId =
            id.replaceAll("left", "right").replaceAll("Left", "Right");
        map[mirroredId] = map[id] ?? false;
      } else if (id.contains("right")) {
        final mirroredId =
            id.replaceAll("right", "left").replaceAll("Right", "Left");
        map[mirroredId] = map[id] ?? false;
      }
    }
    return BodyParts.fromJson(map);
  }

  /// Returns a Map representation of this object.
  ///
  /// Similar to [toJson], but returns a Map<String, bool> instead of a
  /// Map<String, dynamic>.
  Map<String, bool> toMap() {
    return toJson().cast();
  }
}
