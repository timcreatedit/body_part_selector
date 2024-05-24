import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

/// A handle for the [RotationStage] that represents one side of the stage.
///
/// {@template rotation_stage_handle.labels}
/// The handles will obtain their label from the [RotationStageLabels] in the
/// widget tree, and if there is none, fall back to english labels.
///
/// If you want to customize the labels, wrap the [RotationStage] in a
/// [RotationStageLabels] widget with the desired labels.
/// {@endtemplate}
class RotationStageHandle extends StatelessWidget {
  /// Creates a [RotationStageHandle].
  const RotationStageHandle({
    required this.side,
    required this.active,
    required this.onTap,
    required this.backgroundTransparent,
    this.activeForegroundColor,
    this.inactiveForegroundColor,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
    super.key,
  });

  /// The [RotationStageSide] to represent.
  final RotationStageSide side;

  /// Whether this handle is active (the side is currently visible).
  final bool active;

  /// Whether the background of the handle is transparent.
  final bool backgroundTransparent;

  /// The callback to call when the handle is tapped.
  final VoidCallback onTap;

  /// The color of the foreground when the handle is active.
  ///
  /// Defaults to [ThemeData.colorScheme.onPrimary].
  final Color? activeForegroundColor;

  /// The color of the foreground when the handle is inactive.
  ///
  /// Defaults to [ThemeData.colorScheme.onPrimaryContainer].
  final Color? inactiveForegroundColor;

  /// The color of the background when the handle is active.
  ///
  /// Defaults to [ThemeData.colorScheme.primary].
  final Color? activeBackgroundColor;

  /// The color of the background when the handle is inactive.
  ///
  /// Defaults to [ThemeData.colorScheme.primaryContainer].
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
