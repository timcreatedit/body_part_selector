import 'dart:math';

import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:body_part_selector/src/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable/touchable.dart';

/// A widget that allows for selecting body parts.
class BodyPartSelector extends StatelessWidget {
  /// Creates a [BodyPartSelector].
  const BodyPartSelector({
    required this.bodyParts,
    required this.onSelectionUpdated,
    required this.side,
    this.mirrored = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
    super.key,
  });

  /// {@template body_part_selector.body_parts}
  /// The current selection of body parts
  /// {@endtemplate}
  final BodyParts bodyParts;

  /// The side of the body to display.
  final BodySide side;

  /// {@template body_part_selector.on_selection_updated}
  /// Called when the selection of body parts is updated with the new selection.
  /// {@endtemplate}
  final void Function(BodyParts bodyParts)? onSelectionUpdated;

  /// {@template body_part_selector.mirrored}
  /// Whether the selection should be mirrored, or symmetric, such that when
  /// selecting the left arm for example, the right arm is selected as well.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool mirrored;

  /// {@template body_part_selector.selected_color}
  /// The color of the selected body parts.
  ///
  /// Defaults to [ThemeData.colorScheme.inversePrimary].
  /// {@endtemplate}
  final Color? selectedColor;

  /// {@template body_part_selector.unselected_color}
  /// The color of the unselected body parts.
  ///
  /// Defaults to [ThemeData.colorScheme.inverseSurface].
  /// {@endtemplate}
  final Color? unselectedColor;

  /// {@template body_part_selector.selected_outline_color}
  /// The color of the outline of the selected body parts.
  ///
  /// Defaults to [ThemeData.colorScheme.primary].
  /// {@endtemplate}
  final Color? selectedOutlineColor;

  /// {@template body_part_selector.unselected_outline_color}
  /// The color of the outline of the unselected body parts.
  ///
  /// Defaults to [ThemeData.colorScheme.onInverseSurface].
  /// {@endtemplate}
  final Color? unselectedOutlineColor;

  @override
  Widget build(BuildContext context) {
    final notifier = SvgService.instance.getSide(side);
    return ValueListenableBuilder<DrawableRoot?>(
      valueListenable: notifier,
      builder: (context, value, _) {
        if (value == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return _buildBody(context, value);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, DrawableRoot drawable) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: SizedBox.expand(
        key: ValueKey(bodyParts),
        child: CanvasTouchDetector(
          gesturesToOverride: const [GestureType.onTapDown],
          builder: (context) => CustomPaint(
            painter: _BodyPainter(
              root: drawable,
              bodyParts: bodyParts,
              onTap: (s) => onSelectionUpdated?.call(
                bodyParts.withToggledId(s, mirror: mirrored),
              ),
              context: context,
              selectedColor: selectedColor ?? colorScheme.inversePrimary,
              unselectedColor: unselectedColor ?? colorScheme.inverseSurface,
              selectedOutlineColor: selectedOutlineColor ?? colorScheme.primary,
              unselectedOutlineColor:
                  unselectedOutlineColor ?? colorScheme.onInverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.root,
    required this.bodyParts,
    required this.onTap,
    required this.context,
    required this.selectedColor,
    required this.unselectedColor,
    required this.unselectedOutlineColor,
    required this.selectedOutlineColor,
  });

  final DrawableRoot root;
  final BuildContext context;
  final void Function(String) onTap;
  final BodyParts bodyParts;
  final Color selectedColor;
  final Color unselectedColor;
  final Color unselectedOutlineColor;

  final Color selectedOutlineColor;

  bool isSelected(String key) {
    final selections = bodyParts.toJson();
    if (selections.containsKey(key) && selections[key]!) {
      return true;
    }
    return false;
  }

  void drawBodyParts({
    required TouchyCanvas touchyCanvas,
    required Canvas plainCanvas,
    required Size size,
    required Iterable<Drawable> drawables,
    required Matrix4 fittingMatrix,
  }) {
    for (final element in drawables) {
      final id = element.id;
      if (id == null) {
        debugPrint("Found a drawable element without an ID. Skipping $element");
        continue;
      }
      touchyCanvas.drawPath(
        (element as DrawableShape).path.transform(fittingMatrix.storage),
        Paint()
          ..color = isSelected(id) ? selectedColor : unselectedColor
          ..style = PaintingStyle.fill,
        onTapDown: (_) => onTap(id),
      );
      plainCanvas.drawPath(
        element.path.transform(fittingMatrix.storage),
        Paint()
          ..color =
              isSelected(id) ? selectedOutlineColor : unselectedOutlineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size != root.viewport.viewBoxRect.size) {
      final double scale = min(
        size.width / root.viewport.viewBoxRect.width,
        size.height / root.viewport.viewBoxRect.height,
      );
      final scaledHalfViewBoxSize =
          root.viewport.viewBoxRect.size * scale / 2.0;
      final halfDesiredSize = size / 2.0;
      final shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );

      final bodyPartsCanvas = TouchyCanvas(context, canvas);

      final fittingMatrix = Matrix4.identity()
        ..translate(shift.dx, shift.dy)
        ..scale(scale);

      final drawables =
          root.children.where((element) => element.hasDrawableContent);

      drawBodyParts(
        touchyCanvas: bodyPartsCanvas,
        plainCanvas: canvas,
        size: size,
        drawables: drawables,
        fittingMatrix: fittingMatrix,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
