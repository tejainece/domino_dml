import 'dart:async';
import 'package:domino/domino.dart';
import 'package:domino/node_helpers.dart';
import 'package:domino_dml/domino_dml.dart';

class TodoItem implements Component, ConfigurableComponent {
  String task;

  final StreamController<void> _click = new StreamController();

  Stream<void> get onClick => _click.stream;

  @override
  void setProperty(String name, value) {
    if (name == 'task') task = value;
  }

  @override
  getProperty(String name) {
    if (name == 'task') return task;
  }

  @override
  dynamic build(BuildContext context) =>
      div(content: task, events: {'click': (_) => _click.add(null)});

  @override
  Stream getEvent(String event) {
    if(event == 'onClick') return onClick;
    return null;
  }
}

String getTask() => 'Laundry';

void main() {
  dml('''
  <TodoItem [task]="task" (click)="todoItemClick"></TodoItem>
  ''')
    ..bindings = {
      'task': getTask(),
    }
    ..events = {
      'todoItemClick': (_) => print('TodoItem clicked!'),
    }..components = {

  };

  // TODO querySelector('#output').text = 'Your Dart app is running.';
}
