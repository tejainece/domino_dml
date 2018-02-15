import 'dart:async';
import 'package:xml/xml.dart';
import 'package:domino/domino.dart';

abstract class ConfigurableComponent {
  void setProperty(String name, value);

  getProperty(String name);
}

class DmlTemplate implements Component {
  @override
  dynamic build(_) {
    XmlDocument doc = parse(template);
    doc.children.forEach(())
    // TODO
  }

  List _construct(XmlElement spec) {
    List ret = [];

    for(XmlElement ch in spec.children) {
      if(!components.containsKey(ch.name)) continue;

      dynamic temp = components[ch.name];
      if(temp is Function) temp = temp();

      if(temp is ConfigurableComponent) {
        for(XmlAttribute attribute in ch.attributes) {

        }
      }
    }

  }

  DmlTemplate(this.template);

  String template;

  Map<String, dynamic> bindings;

  Map<String, dynamic> events;

  Map<String, dynamic> components;
}

DmlTemplate dml(String template) => new DmlTemplate(template);
