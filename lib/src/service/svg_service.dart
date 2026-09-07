import 'dart:async';

import 'package:body_part_selector/body_part_selector.dart';
import 'package:body_part_selector/src/model/parsed_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A singleton service that loads the SVGs for the body sides.
class SvgService {
  SvgService._() {
    _init();
  }

  static final SvgService _instance = SvgService._();

  /// The singleton instance of [SvgService].
  static SvgService get instance => _instance;

  final ValueNotifier<ParsedBody?> _front = ValueNotifier(null);
  final ValueNotifier<ParsedBody?> _left = ValueNotifier(null);
  final ValueNotifier<ParsedBody?> _back = ValueNotifier(null);
  final ValueNotifier<ParsedBody?> _right = ValueNotifier(null);

  /// The [ValueNotifier] for the given [side].
  ///
  /// It's value is null until the SVG is loaded.
  ValueNotifier<ParsedBody?> getSide(BodySide side) => side.map(
        front: _front,
        left: _left,
        back: _back,
        right: _right,
      );

  Future<void> _init() async {
    await Future.wait([
      for (final side in BodySide.values) _loadParsedBody(side, getSide(side)),
    ]);
  }

  Future<void> _loadParsedBody(
    BodySide side,
    ValueNotifier<ParsedBody?> notifier,
  ) async {
    final svgString = await rootBundle.loadString(
      side.map(
        front: "packages/body_part_selector/m_front.svg",
        left: "packages/body_part_selector/m_left.svg",
        back: "packages/body_part_selector/m_back.svg",
        right: "packages/body_part_selector/m_right.svg",
      ),
    );
    notifier.value = ParsedBody.parse(svgString);
  }
}
