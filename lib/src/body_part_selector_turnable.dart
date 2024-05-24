import 'package:body_part_selector/src/body_part_selector.dart';
import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

export 'package:rotation_stage/rotation_stage.dart';

/// A widget that allows for selecting body parts on a turnable body.
///
/// This widget is a wrapper around [RotationStage] and [BodyPartSelector].
class BodyPartSelectorTurnable extends StatelessWidget {
  /// Creates a [BodyPartSelectorTurnable].
  const BodyPartSelectorTurnable({
    required this.bodyParts,
    super.key,
    this.onSelectionUpdated,
    this.mirrored = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
    this.padding = EdgeInsets.zero,
    this.labelData,
  });

  /// {@macro body_part_selector.body_parts}
  final BodyParts bodyParts;

  /// {@macro body_part_selector.on_selection_updated}
  final ValueChanged<BodyParts>? onSelectionUpdated;

  /// {@macro body_part_selector.mirrored}
  final bool mirrored;

  /// {@macro body_part_selector.selected_color}
  final Color? selectedColor;

  /// {@macro body_part_selector.unselected_color}

  final Color? unselectedColor;

  /// {@macro body_part_selector.selected_outline_color}

  final Color? selectedOutlineColor;

  /// {@macro body_part_selector.unselected_outline_color}
  final Color? unselectedOutlineColor;

  /// The padding around the rendered body.
  final EdgeInsets padding;

  /// The labels for the sides of the [RotationStage].
  final RotationStageLabelData? labelData;

  @override
  Widget build(BuildContext context) {
    return RotationStageLabels(
      data: labelData ?? RotationStageLabelData.english,
      child: RotationStage(
        contentBuilder: (index, side, page) => Padding(
          padding: padding,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BodyPartSelector(
              side: side.map(
                front: BodySide.front,
                left: BodySide.left,
                back: BodySide.back,
                right: BodySide.right,
              ),
              bodyParts: bodyParts,
              onSelectionUpdated: onSelectionUpdated,
              mirrored: mirrored,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              selectedOutlineColor: selectedOutlineColor,
              unselectedOutlineColor: unselectedOutlineColor,
            ),
          ),
        ),
      ),
    );
  }
}
