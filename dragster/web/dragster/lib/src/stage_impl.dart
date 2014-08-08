library stage_impl;

import 'dart:html';
import '../stage_api.dart';



class StageImpl extends Stage {
  
  Element _stage = document.querySelector('#columns');
  
  Element getStage(){
    return _stage;
  }
  
  
  void start(){
    
  }
  
  void run(){}
  
}