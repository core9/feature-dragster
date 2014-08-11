library select_impl;


import 'dart:html';
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
  
  void start() {
    initSelect();
  }

  List<Element> getSelectedElements() {
    return document.querySelectorAll('.' + _selectClass);
  }

  void initSelect() {
    _stage.getAllElements().forEach((e) => activateSelect(e));
  }

  void activateSelect(Element e) {
    e.onClick.listen(_selectClick);
  }

  void _selectClick(MouseEvent event) {
    Element element = event.target;
    if (_ifSelectElement(element)) return;
    
    if(element.classes.contains(_selectClass)){
      _selectElementOff(element);
    }else{
      _selectElement(element);
    }
    
  }

  bool _ifSelectElement(Element element) {
    if (element == null) return true;
    if (element.id == _stage.getStageId().trim().split('#')[1]) return true;
    if (element.classes.contains('resize')) return true;
    return false;
  }

  
  void _selectElement(Element element){
    element.classes.add(_selectClass);
  }
  
  void _selectElementOff(Element element){
    element.classes.remove(_selectClass);
  }

}