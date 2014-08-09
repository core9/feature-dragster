library highlight_impl;

import "package:dice/dice.dart";

import 'dart:html';
import 'dart:convert';
import '../highlight_api.dart';
import '../stage_api.dart';


class HighLightImpl extends HighLight {
  

  
  @inject
  Stage _stage;
  
  void start(){}
  
  void initHighlight() {
    _stage.getAllElements().forEach((e) => activateHighLight(e));
  }

  void activateHighLight(Element e) {
    e.onMouseOver.listen(_highLightOnMouseOver);
    e.onMouseOut.listen(_highLightOnMouseOut);
  }
  
  void _highLightOnMouseOver(MouseEvent event) {
    Element element = event.target;
    if (element == null) return;
    if (element.id == 'columns') return;
    if (element.classes.contains('resize')) return;
    
    String border = element.style.border;
     int width = element.clientWidth;
     int height = element.clientHeight;
     var mapData = new Map();
     var cssData = new Map();
     cssData["border"] = border;
     cssData["width"] = width.toString() + 'px';
     cssData["height"] = height.toString() + 'px';
     mapData["properties"] = new List();
     mapData["properties"].add(cssData);
     String jsonData = JSON.encode(mapData);
     document.querySelector('#hover-placeholder').text = jsonData;
     element.style.setProperty('width', (width - 4).toString() + 'px');
     element.style.setProperty('height', (height - 4).toString() + 'px');
     element.style.setProperty('border', '2px solid lightblue');
     element.classes.add('highlight');
  }

  void _highLightOnMouseOut(MouseEvent event) {
    Element element = event.target;
    resetOnMouseOver(element);
  }

  void resetOnMouseOver(Element element) {
    if (element == null) return;
    if (element.id == 'columns') return;
    if (element.classes.contains('resize')) return;
    print('mouse leave');
    String properties = document.querySelector('#hover-placeholder').text;
    if (properties == '') return;
    var json = JSON.decode(properties);
    List<Map> cssProperties = json['properties'];
    cssProperties.forEach((e) => _setProperties(element, e));
    element.classes.remove('highlight');
  }

  void _setProperties(Element element, Map e) {
    e.keys.forEach((key) => element.style.setProperty(key, e[key]));
  }
  
}