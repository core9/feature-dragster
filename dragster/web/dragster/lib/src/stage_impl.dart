library stage_impl;

import 'dart:html';

import '../stage_api.dart';
import '../menu_api.dart';


class StageImpl extends Stage {
  
  
  Menu _menu;
  
  Element _stage = document.querySelector('#columns');
  List<Element> _stageElements = document.querySelectorAll('#columns');
  
  Element getStage(){
    return _stage;
  }
  
  List<Element> getStageElements(){
    return _stageElements;
  }
 
  void setMenu(Menu menu){
    _menu = menu;
  }
  
  Menu getMenu(){
    return _menu;
  }
  
  void start(){
    
  }
  
  void run(){}
  
}