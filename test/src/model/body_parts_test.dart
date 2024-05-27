import 'package:body_part_selector/src/model/body_parts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("BodyParts", () {
    group('.all', () {
      test("Equals all", () {
        // ignore: use_named_constants
        const bp = BodyParts(
          head: true,
          neck: true,
          upperBody: true,
          abdomen: true,
          vestibular: true,
          leftElbow: true,
          leftFoot: true,
          leftHand: true,
          leftKnee: true,
          leftLowerArm: true,
          leftLowerLeg: true,
          leftShoulder: true,
          leftUpperArm: true,
          leftUpperLeg: true,
          lowerBody: true,
          rightElbow: true,
          rightFoot: true,
          rightHand: true,
          rightKnee: true,
          rightLowerArm: true,
          rightLowerLeg: true,
          rightShoulder: true,
          rightUpperArm: true,
          rightUpperLeg: true,
        );
        expect(bp, BodyParts.all);
      });

      test("Doesn't equal any off", () {
        const bp = BodyParts.all;
        for (final key in bp.toMap().keys) {
          final bp = BodyParts.all.withToggledId(key);
          expect(bp, isNot(BodyParts.all));
        }
        expect(bp, BodyParts.all);
      });
    });

    group('.withToggledId', () {
      void testIdToggle(String id) {
        const bp = BodyParts();
        expect(
          bp.toJson()[id],
          false,
          reason: id,
        );
        expect(
          bp.withToggledId(id).toJson()[id],
          true,
          reason: id,
        );
        expect(
          bp.withToggledId(id).withToggledId(id).toJson()[id],
          false,
          reason: id,
        );
        expect(
          bp.withToggledId(id, mirror: true).toJson()[id],
          true,
          reason: id,
        );
        expect(
          bp
              .withToggledId(id, mirror: true)
              .withToggledId(id, mirror: true)
              .toJson()[id],
          false,
          reason: id,
        );
      }

      test("Toggling by symmetric IDs works", () {
        const ids = ["head", "neck", "upperBody", "abdomen", "vestibular"];
        for (final id in ids) {
          testIdToggle(id);
        }
      });

      test("Toggling by asymmetric IDs works", () {
        const ids = [
          "Shoulder",
          "UpperArm",
          "Elbow",
          "LowerArm",
          "Hand",
          "UpperLeg",
          "Knee",
          "LowerLeg",
          "Foot",
        ];

        void testIds(String leftId, String rightId) {
          testIdToggle(leftId);
          testIdToggle(rightId);
          const bp = BodyParts();

          expect(
            bp.withToggledId(leftId).toJson()[rightId],
            false,
            reason: "$leftId on, should leave off $rightId",
          );
          expect(
            bp.withToggledId(leftId, mirror: true).toJson()[rightId],
            true,
            reason: "$leftId on mirrored, should turn on $rightId",
          );
          expect(
            bp.withToggledId(rightId).toJson()[leftId],
            false,
            reason: "$rightId on, should leave off $leftId",
          );
          expect(
            bp.withToggledId(rightId, mirror: true).toJson()[leftId],
            true,
            reason: "$rightId on mirrored, should turn on $leftId",
          );
          expect(
            bp
                .withToggledId(rightId, mirror: true)
                .withToggledId(rightId, mirror: true)
                .toJson()[leftId],
            false,
            reason: "$rightId on and off mirrored, should leave off $leftId",
          );
          expect(
            bp
                .withToggledId(leftId, mirror: true)
                .withToggledId(leftId, mirror: true)
                .toJson()[rightId],
            false,
            reason: "$leftId on and off mirrored, should leave off $rightId",
          );
          expect(
            bp
                .withToggledId(leftId)
                .withToggledId(rightId, mirror: true)
                .toJson()[rightId],
            true,
            reason:
                "$leftId on, then $rightId on mirrored should turn on $rightId",
          );
          expect(
            bp
                .withToggledId(leftId)
                .withToggledId(leftId, mirror: true)
                .toJson()[rightId],
            false,
            reason: "$leftId on, then $leftId off mirrored, should leave off "
                "$rightId",
          );
          expect(
            bp
                .withToggledId(rightId)
                .withToggledId(leftId)
                .withToggledId(leftId, mirror: true)
                .toJson()[rightId],
            false,
            reason: "$rightId, then $leftId on, then $leftId mirrored off "
                "should turn off $rightId",
          );
        }

        for (final partId in ids) {
          final leftId = "left$partId";
          final rightId = "right$partId";
          testIds(leftId, rightId);
        }
      });
    });
  });
}
