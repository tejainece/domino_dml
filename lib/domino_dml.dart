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
        // TODO substitute text bindings
        ret.add(ch.text);
      } else if (ch is XmlElement) {
        if (!components.containsKey(ch.name.local)) continue;

        dynamic temp = components[ch.name.local];
        while (temp is Function) temp = temp();

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
          // TODO add children
        } else if (temp is Element) {
          // TODO update element

          for (XmlAttribute attribute in ch.attributes) {
            String name = attribute.name.local;
            String value = attribute.value;
            if (value.startsWith('{{') && value.endsWith('}}')) {
              if (bindings.containsKey(attribute.value)) {
                if (name.startsWith('style.')) {
                  temp.style(name.substring('style.'.length),
                      bindings[attribute.value]);
                } else if (name.startsWith('class.')) {
                  temp.addClass(name.substring('class.'.length));
                } else if (name == 'classes') {
                  // TODO split?
                  temp.addClass(bindings[attribute.value]);
                } else if (name.startsWith('on.')) {
                  temp.on(
                      name.substring('on.'.length), bindings[attribute.value]);
                } else {
                  temp.attr(name, bindings[attribute.value]);
                }
                // TODO
              }
            } else {
              if (name.startsWith('style.')) {
                temp.style(name.substring('style.'.length), value);
              } else if (name.startsWith('on.')) {
                // TODO throw?
              }
              // TODO
            }
          }

          // TODO add children
        } else {
          throw new UnsupportedError(
              'Only ConfigurableComponent or Element are supported!');
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
