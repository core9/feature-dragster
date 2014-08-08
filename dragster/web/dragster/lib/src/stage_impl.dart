library stage_impl;

import 'dart:html';
import '../stage_api.dart';



class StageImpl extends Stage {
  
  Element _stage = document.querySelector('#columns');
  List<Element> _stageElements = document.querySelectorAll('#columns');
  
  Element getStage(){
    return _stage;
  }
  
  List<Element> getStageElements(){
    return _stageElements;
  }
  
  void start(){
    
  }
  
  void run(){}
  
}