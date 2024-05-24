# Rotation Stage

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

A four-sided stage for representing 3D objects with four widgets
![Demo GIF](https://raw.githubusercontent.com/fyzio/rotation_stage/main/example/demo.gif)


## Installation 💻

**❗ In order to start using Rotation Stage you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add rotation_stage
```

## Usage

The simplest way is to use the ``RotationStage`` widget.
You only have to provide a ``contentBuilder``, everything else is preconfigured.

```dart
Widget build(BuildContext context) {
  return RotationStage(
    contentBuilder: (int index,
        RotationStageSide side,
        double currentPage,) =>
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              side.map(
                front: "Front",
                left: "Left",
                back: "Back",
                right: "Right",
              ),
            ),
          ),
        ),
  );
}
```

You can rotate the widget by swiping on the bottom bar. The top part is purposfully not swipeable,
so you can listen to whatever gestures you want there.

If you want more fine-grained control, check out the other parameters of the constructor, or
``RotationStageBar``, ``RotationStageHandle`` and ``RotationStageContent``.

The source code for ``RotationStage`` should be a good starting point.

## Example

To run the example open the ``example`` folder and run ``flutter create .``

---


[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[mason_link]: https://github.com/felangel/mason
[very_good_ventures_link]: https://verygood.ventures
