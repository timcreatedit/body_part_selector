import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rotation_stage/rotation_stage.dart';

void main() {
  const sideColors = {
    RotationStageSide.front: Colors.red,
    RotationStageSide.back: Colors.green,
    RotationStageSide.left: Colors.blue,
    RotationStageSide.right: Colors.yellow,
  };

  group('RotationStage', () {
    late RotationStageController controller;

    // ignore: prefer_function_declarations_over_variables
    final RotationStageBuilder contentBuilder = (index, side, currentPage) {
      return Container(
        color: sideColors[side],
        key: ValueKey(side),
      );
    };

    Widget build(RotationStage rotationStage) {
      return MaterialApp(
        home: Scaffold(
          body: rotationStage,
        ),
      );
    }

    Widget buildDefault() {
      return build(
        RotationStage(
          contentBuilder: contentBuilder,
          controller: controller,
        ),
      );
    }

    Finder findSide(RotationStageSide side) {
      return find.byKey(ValueKey(side));
    }

    setUp(() {
      controller = RotationStageController();
    });

    group('Content', () {
      testWidgets(
        'shows front side by default',
        (tester) async {
          await tester.pumpWidget(buildDefault());
          await tester.pumpAndSettle();
          final front = findSide(RotationStageSide.front);
          expect(front, findsOneWidget);
          expect(
            front.hitTestable(),
            findsOneWidget,
            reason: "Front side is hit-testable",
          );
        },
      );

      testWidgets('other sides are not in widget tree', (tester) async {
        await tester.pumpWidget(buildDefault());
        await tester.pumpAndSettle();
        final back = findSide(RotationStageSide.back);
        final left = findSide(RotationStageSide.left);
        final right = findSide(RotationStageSide.right);
        expect(back, findsNothing);
        expect(left, findsNothing);
        expect(right, findsNothing);
      });

      testWidgets('animates to other sides', (tester) async {
        await tester.pumpWidget(buildDefault());
        await tester.pumpAndSettle();

        for (final side in RotationStageSide.values) {
          controller.animateToSide(side);
          await tester.pumpAndSettle();
          final foundSide = findSide(side);
          expect(foundSide, findsOneWidget);
          expect(
            foundSide.hitTestable(),
            findsOneWidget,
            reason: "$side side is hit-testable",
          );
          for (final otherSide in RotationStageSide.values) {
            if (otherSide != side) {
              expect(
                findSide(otherSide),
                findsNothing,
                reason: "$otherSide side is not in the widget tree when $side "
                    "is shown",
              );
            }
          }
        }
      });
    });

    group('Rotation Stage Bar', () {
      const labels = RotationStageLabelData.english;

      testWidgets('shows bar with handles', (tester) async {
        await tester.pumpWidget(buildDefault());
        await tester.pumpAndSettle();
        final bar = find.byType(RotationStageBar);
        expect(bar, findsOneWidget);
        final handles = find.byType(RotationStageHandle);
        expect(handles, findsAtLeast(3));
      });

      testWidgets('front handle is active and centered by default',
          (tester) async {
        await tester.pumpWidget(buildDefault());
        await tester.pumpAndSettle();
        final handle = find.handleByText(labels.front);
        expect(handle, findsOneWidget);

        expect(tester.widget<RotationStageHandle>(handle).active, isTrue);
        expect(
          tester.getCenter(handle).dx,
          tester.getCenter(find.byType(MaterialApp)).dx,
        );
      });

      testWidgets('tapping handles changes side', (tester) async {
        await tester.pumpWidget(buildDefault());
        await tester.pumpAndSettle();

        for (final side in RotationStageSide.values) {
          final handle = find.handleByText(labels.getForSide(side));
          await tester.tap(handle);
          await tester.pumpAndSettle();
          expect(
            findSide(side),
            findsOneWidget,
            reason: "$side side is shown after tapping its handle",
          );
          expect(
            tester.firstWidget<RotationStageHandle>(handle).active,
            isTrue,
            reason: "$side handle is active after tapping",
          );
        }
      });
    });
  });
}

extension on CommonFinders {
  Finder handleByText(String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(RotationStageHandle),
    );
  }
}
