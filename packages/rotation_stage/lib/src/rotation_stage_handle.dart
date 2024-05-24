import 'package:flutter/material.dart';
import 'package:rotation_stage/src/model/rotation_stage_side.dart';
import 'package:rotation_stage/src/rotation_stage_labels.dart';

class RotationStageHandle extends StatelessWidget {
  const RotationStageHandle({
    super.key,
    required this.side,
    required this.active,
    required this.onTap,
    required this.backgroundTransparent,
    this.activeForegroundColor,
    this.inactiveForegroundColor,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
  });

  final RotationStageSide side;
  final bool active;
  final bool backgroundTransparent;
  final VoidCallback onTap;

  final Color? activeForegroundColor;
  final Color? inactiveForegroundColor;
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labels = RotationStageLabels.of(context);
    final name = labels.getForSide(side);
    return RawChip(
      showCheckmark: false,
      onSelected: (_) => onTap(),
      label: Text(
        name.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: active
                  ? activeForegroundColor ?? colorScheme.onPrimary
                  : inactiveForegroundColor ?? colorScheme.onPrimaryContainer,
            ),
      ),
      selected: active,
      disabledColor: Colors.transparent,
      shadowColor:
          backgroundTransparent ? Colors.transparent : colorScheme.shadow,
      selectedShadowColor: backgroundTransparent
          ? Colors.transparent
          : activeBackgroundColor ?? colorScheme.primary,
      backgroundColor: backgroundTransparent
          ? Colors.transparent
          : inactiveBackgroundColor ?? colorScheme.primaryContainer,
      selectedColor: backgroundTransparent
          ? Colors.transparent
          : activeBackgroundColor ?? colorScheme.primary,
    );
  }
}
