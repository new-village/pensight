class Note {
  final int id;
  String title;
  String content;
  static int _counter = 0;

  Note({required this.title, this.content = ''}) : id = _counter++;
}
