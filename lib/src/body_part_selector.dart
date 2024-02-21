import 'dart:math';

import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:body_part_selector/src/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable/touchable.dart';

class BodyPartSelector extends StatelessWidget {
  const BodyPartSelector({
    super.key,
    required this.side,
    required this.bodyParts,
    required this.onSelectionUpdated,
    this.mirrored = false,
    this.singleSelection = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
  });

  final BodySide side;
  final BodyParts bodyParts;
  final void Function(BodyParts bodyParts)? onSelectionUpdated;

  final bool mirrored;
  final bool singleSelection;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedOutlineColor;
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
        });
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
              // onTap: (s) => 
              // onSelectionUpdated?.call(
              //   bodyParts.withToggledId(s, mirror: mirrored),
              // ),
              onTap: (s) {
  // print('Selected ID: $bodyParts');
  onSelectionUpdated?.call(
    bodyParts.withToggledId(s, mirror: mirrored,singleSelection : singleSelection),
  );
},
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
      final Size scaledHalfViewBoxSize =
          root.viewport.viewBoxRect.size * scale / 2.0;
      final Size halfDesiredSize = size / 2.0;
      final Offset shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );

      final bodyPartsCanvas = TouchyCanvas(context, canvas);

      final Matrix4 fittingMatrix = Matrix4.identity()
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
