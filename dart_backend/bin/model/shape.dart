class Shape {
  int x;
  int y;
  String color;
  int size;

  Shape(this.x, this.y, this.color, this.size);
  @override
  String toString() {
    return '''{ x: $x , y:$y, color: $color, size: $size } 
    ''';
  }
}
