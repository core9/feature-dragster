library selectionpropertiesimpl;

import 'dart:html';
import 'dart:convert';
import '../selectionproperties_api.dart';


class SelectionPropertiesImpl implements SelectionProperties {


  List<Element> getAllInputFields() {
    return document.querySelectorAll('#selection-properties input');
  }


  void start() {
    print('selection properties starting');

    getAllInputFields().forEach((e) => _prepareFormElements(e));

  }

  void _prepareFormElements(Element element) {


    print(element.tagName);

    element.onChange.listen(_onInputChange);

  }

  void _onInputChange(Event event) {
    InputElement element = event.target;
    print('input type : ');
    print(element.type);
    print('changed propertie : ');
    print(element.name);
    print('value : ');
    print(element.value);

    if (element.name != 'width' && element.name != 'height') {
      return;
    }


    var cssData = new Map();
    cssData[element.name] = element.value;


    List<Element> selectedElements = document.querySelectorAll('.select');
    selectedElements.forEach((e) => _setProperties(e, cssData));
  }

  void _setProperties(Element element, Map map) {
    map.keys.forEach((key) => _applyStyle(element, map, key));
  }

  void _applyStyle(Element element, Map map, String key) {
    if (element.classes.contains('content')) {
      if (key == 'width' || key == 'height') {
        element.parent.style.setProperty(key, (int.parse(map[key]) + 4).toString() + 'px');
        element.style.setProperty(key, map[key] + 'px');
      }
    } else {
      if (key == 'width' || key == 'height') {
        element.style.setProperty(key, map[key] + 'px');
      }
    }

  }

}
