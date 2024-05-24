/// Represents the side from which the body is viewed.
///
/// Values are ordered as if looking at the person from the front, and them
/// then rotating them clockwise, so that their left side is visible next.
enum BodySide {
  /// The front (ventral) side of the body.
  ///
  /// As if looking the person in the face.
  front,

  /// The left (sinister) side of the body, where the person's left hand is.
  left,

  /// The back (dorsal) side of the body.
  ///
  /// As if looking at the person's back.
  back,

  /// The right (dexter) side of the body, where the person's right hand is.
  right;

  /// Returns the [BodySide] for the given index.
  static BodySide forIndex(int i) => values[i % values.length];

  /// Maps the side to a value of type [T].
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
