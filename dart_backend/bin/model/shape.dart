class Shape {
  int id;
  int x;
  int y;
  String color;
  int size;

  Shape(this.id, this.x, this.y, this.color, this.size);
  @override
  String toString() {
    return '''id: $id, x: $x, y:$y, color: $color, size: $size
    ''';
  }
}
