library select_impl;


import 'dart:html';
import 'dart:convert';
import '../select_api.dart';
import '../stage_api.dart';


class SelectImpl extends Select {

  Stage _stage;
  String _selectClass = 'select';

  void setStage(Stage stage) {
    _stage = stage;
  }

  Element _getSelectPlaceHolder(){
    return document.querySelector('#select-placeholder');
  }
  
  void start() {}

  List<Element> getSelectedElements() {
    return document.querySelectorAll('.' + _selectClass);
  }

  void initSelect() {
    _stage.getAllElements().forEach((e) => activateSelect(e));
  }

  void activateSelect(Element e) {
    e.onMouseOver.listen(_selectOnMouseOver);
    e.onMouseOut.listen(_selectOnMouseOut);
  }

  void _selectOnMouseOver(MouseEvent event) {
    Element element = event.target;
    if (_ifSelectElement(element)) return;
    _selectElement(element);
  }
  
  void _selectOnMouseOut(MouseEvent event) {
    Element element = event.target;
    resetOnMouseOver(element);
  }

  void resetOnMouseOver(Element element) {
    if (_ifSelectElement(element)) return;
    _selectElementOff(element);
  }

  /*
   * real code 
   */

  bool _ifSelectElement(Element element) {
    if (element == null) return true;
    if (element.id == _stage.getStageId().trim().split('#')[1]) return true;
    if (element.classes.contains('resize')) return true;
    return false;
  }

  
  void _selectElement(Element element){
    var mapData = new Map();
    var cssData = new Map();
    int width = element.clientWidth;
    int height = element.clientHeight;
    cssData["border"] = element.style.border;
    cssData["width"] = width.toString() + 'px';
    cssData["height"] = height.toString() + 'px';
    mapData["properties"] = new List();
    mapData["properties"].add(cssData);
    _getSelectPlaceHolder().text = JSON.encode(mapData);
    element.style.setProperty('width', (width - 4).toString() + 'px');
    element.style.setProperty('height', (height - 4).toString() + 'px');
    element.style.setProperty('border', '2px solid lightblue');
    element.classes.add(_selectClass);
  }
  
  void _selectElementOff(Element element){
    String properties = _getSelectPlaceHolder().text;
    if (properties == '') return;
    JSON.decode(properties)['properties'].forEach((e) => _setProperties(element, e));
    element.classes.remove(_selectClass);
  }
  
  
  void _setProperties(Element element, Map e) {
    e.keys.forEach((key) => element.style.setProperty(key, e[key]));
  }

}