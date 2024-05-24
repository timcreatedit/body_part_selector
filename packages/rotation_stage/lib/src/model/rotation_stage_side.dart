enum RotationStageSide {
  front,
  left,
  back,
  right;

  static RotationStageSide forIndex(int i) => values[i % values.length];

  T map<T>({
    required T front,
    required T left,
    required T back,
    required T right,
  }) {
    switch (this) {
      case RotationStageSide.front:
        return front;
      case RotationStageSide.left:
        return left;
      case RotationStageSide.back:
        return back;
      case RotationStageSide.right:
        return right;
    }
  }
}
