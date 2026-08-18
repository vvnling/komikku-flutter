import 'package:web/web.dart' as web;

final List<String> _marks = [];

void bootMark(String stage) {
  _marks.add(stage);
  web.document.title = 'boot:${_marks.join('>')}';
}
