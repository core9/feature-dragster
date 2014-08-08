library main;

import 'dragdrop_api.dart';

import 'bootstrategy_api.dart';

class MainStrategy implements BootStrategy {
  InjectorWrap _injectorWrap;
  void processPlugins(){
    DragDrop dragdrop = _injectorWrap.getInjector().getInstance(DragDrop);
    dragdrop.start();
    
  }
  void setRegistry(InjectorWrap injectorWrap){
    _injectorWrap = injectorWrap;
  }
  int getPriority(){ return 0;}
  
}

