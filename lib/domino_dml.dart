import 'dart:async';
import 'package:xml/xml.dart';
import 'package:domino/domino.dart';

abstract class ConfigurableComponent {
  void setProperty(String name, value);

  getProperty(String name);

  Stream getEvent(String event);
}

class DmlTemplate implements Component {
  @override
  dynamic build(_) {
    XmlDocument doc = parse(template);
    // TODO
  }

  DmlTemplate(this.template);

  String template;

  Map<String, dynamic> bindings;

  Map<String, dynamic> events;

  dynamic components;
}

DmlTemplate dml(String template) => new DmlTemplate(template);
