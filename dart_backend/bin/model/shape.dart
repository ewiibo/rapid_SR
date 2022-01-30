class Shape {
  int id;
  int x;
  int y;

  Shape(this.id, this.x, this.y);
  @override
  String toString() {
    return '''id: $id, x: $x, y:$y
    ''';
  }
}
