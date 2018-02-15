import 'package:xml/xml.dart';
import 'package:domino/domino.dart';
import 'package:domino/node_helpers.dart';

abstract class ConfigurableComponent {
  void setProperty(String name, value);

  getProperty(String name);
}

class DmlTemplate implements Component {
  @override
  dynamic build(_) {
    XmlDocument doc = parse(template);
    final ret = _construct(doc);
    return ret;
  }

  dynamic _construct(XmlNode spec) {
    List ret = [];
    for (XmlNode ch in spec.children) {
      if (ch is XmlText) {
        ret.add(ch.text);
      } else if (ch is XmlElement) {
        if (!components.containsKey(ch.name.local)) continue;

        dynamic temp = components[ch.name.local];
        if (temp is Function) temp = temp();

        if (temp is ConfigurableComponent) {
          for (XmlAttribute attribute in ch.attributes) {
            String name = attribute.name.local;
            String value = attribute.value;
            if (value.startsWith('{{') && value.endsWith('}}')) {
              if (bindings.containsKey(attribute.value))
                temp.setProperty(name, bindings[attribute.value]);
            } else {
              temp.setProperty(name, attribute.value);
            }
          }
        }
        ret.add(temp);
      } else {
        throw new UnsupportedError('Invalid XML type!');
      }
    }
    return ret;
  }

  DmlTemplate(this.template);

  String template;

  Map<String, dynamic> bindings;

  Map<String, dynamic> components;
}

DmlTemplate dml(String template) => new DmlTemplate(template);
