import 'dart:async';
import 'dart:html';
import 'package:domino/domino.dart';
import 'package:domino/html_view.dart';
import 'package:domino/node_helpers.dart';
import 'package:domino_dml/domino_dml.dart';

import 'package:xml/xml.dart';

class TodoItem implements Component, ConfigurableComponent {
  String task;

  final StreamController<void> _click = new StreamController();

  Stream<void> get onClick => _click.stream;

  @override
  void setProperty(String name, value) {
    if (name == 'task')
      task = value;
    else if (name == 'onClick') onClick.listen(value);
  }

  @override
  getProperty(String name) {
    if (name == 'task') return task;
  }

  @override
  dynamic build(BuildContext context) =>
      div(content: task, events: {'click': (_) => _click.add(null)});
}

String getTask() => 'Laundry';

void main() {
  final c = dml('''
  <TodoItem task="{{task}}" onClick="{{todoItemClick}}"></TodoItem>
  ''')
    ..bindings = {
      '{{task}}': getTask(),
      '{{todoItemClick}}': (_) => print('TodoItem clicked!'),
    }
    ..components = {
      'TodoItem': () => new TodoItem(),
    };

  registerHtmlView(querySelector('#output'), c);
}
