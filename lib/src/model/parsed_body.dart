import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

/// A single `<path>` element parsed out of a body SVG, keeping its id so it
/// can be individually hit-tested and colored.
class ParsedBodyPath {
  /// Creates a [ParsedBodyPath].
  const ParsedBodyPath({required this.id, required this.path});

  /// The SVG element's `id` attribute.
  final String id;

  /// The parsed `d` attribute of the SVG path.
  final Path path;
}

/// The result of parsing one of the body SVGs: its view box and the flat
/// list of paths it contains, in document order.
class ParsedBody {
  /// Creates a [ParsedBody].
  const ParsedBody({required this.viewBox, required this.paths});

  /// Parses [svgSource], an SVG document consisting of a single root `<svg>`
  /// element with a `viewBox` attribute and `<path id="..." d="...">`
  /// children.
  factory ParsedBody.parse(String svgSource) {
    final document = XmlDocument.parse(svgSource);
    final root = document.rootElement;

    final viewBoxAttribute = root.getAttribute('viewBox');
    if (viewBoxAttribute == null) {
      throw const FormatException(
        'Expected the root <svg> to have a viewBox attribute.',
      );
    }
    final viewBoxParts = viewBoxAttribute
        .trim()
        .split(RegExp(r'[\s,]+'))
        .map(double.parse)
        .toList();
    final viewBox = Rect.fromLTWH(
      viewBoxParts[0],
      viewBoxParts[1],
      viewBoxParts[2],
      viewBoxParts[3],
    );

    final paths = [
      for (final element in root.findAllElements('path'))
        ParsedBodyPath(
          id: element.getAttribute('id') ?? '',
          path: parseSvgPathData(element.getAttribute('d') ?? ''),
        ),
    ];

    return ParsedBody(viewBox: viewBox, paths: paths);
  }

  /// The `viewBox` of the root `<svg>` element.
  final Rect viewBox;

  /// The `<path>` elements contained in the SVG, in document order.
  final List<ParsedBodyPath> paths;
}
