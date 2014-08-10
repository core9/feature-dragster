library highlight_impl;



import 'dart:html';
import 'dart:convert';
import '../highlight_api.dart';
import '../stage_api.dart';


class HighLightImpl extends HighLight {

  Stage _stage;
  String _highLightClass = 'highlight';

  void setStage(Stage stage) {
    _stage = stage;
  }

  Element _getHoverPlaceHolder(){
    return document.querySelector('#hover-placeholder');
  }
  
  void start() {}

  List<Element> getHighLightedElements() {
    return document.querySelectorAll('.' + _highLightClass);
  }

  void initHighlight() {
    _stage.getAllElements().forEach((e) => activateHighLight(e));
  }

  void activateHighLight(Element e) {
    e.onMouseOver.listen(_highLightOnMouseOver);
    e.onMouseOut.listen(_highLightOnMouseOut);
  }

  void _highLightOnMouseOver(MouseEvent event) {
    Element element = event.target;
    if (_ifHighLightElement(element)) return;
    _highLightElement(element);
  }
  
  void _highLightOnMouseOut(MouseEvent event) {
    Element element = event.target;
    resetOnMouseOver(element);
  }

  void resetOnMouseOver(Element element) {
    if (_ifHighLightElement(element)) return;
    _highLightElementOff(element);
  }

  /*
   * real code 
   */

  bool _ifHighLightElement(Element element) {
    if (element == null) return true;
    if (element.id == _stage.getStageId().trim().split('#')[1]) return true;
    if (element.classes.contains('resize')) return true;
    return false;
  }

  
  void _highLightElement(Element element){
    var mapData = new Map();
    var cssData = new Map();
    int width = element.clientWidth;
    int height = element.clientHeight;
    cssData["border"] = element.style.border;
    cssData["width"] = width.toString() + 'px';
    cssData["height"] = height.toString() + 'px';
    mapData["properties"] = new List();
    mapData["properties"].add(cssData);
    _getHoverPlaceHolder().text = JSON.encode(mapData);
    element.style.setProperty('width', (width - 4).toString() + 'px');
    element.style.setProperty('height', (height - 4).toString() + 'px');
    element.style.setProperty('border', '2px solid lightblue');
    element.classes.add(_highLightClass);
  }
  
  void _highLightElementOff(Element element){
    String properties = _getHoverPlaceHolder().text;
    if (properties == '') return;
    JSON.decode(properties)['properties'].forEach((e) => _setProperties(element, e));
    element.classes.remove(_highLightClass);
  }
  
  
  void _setProperties(Element element, Map e) {
    e.keys.forEach((key) => element.style.setProperty(key, e[key]));
  }

}
