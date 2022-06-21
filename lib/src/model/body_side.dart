enum BodySide {
  front,
  left,
  back,
  right;

  static BodySide forIndex(int i) => values[i % values.length];

  T map<T>({
    required T front,
    required T left,
    required T back,
    required T right,
  }) {
    switch (this) {
      case BodySide.front:
        return front;
      case BodySide.left:
        return left;
      case BodySide.back:
        return back;
      case BodySide.right:
        return right;
    }
  }
}
