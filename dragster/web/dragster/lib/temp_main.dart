library main;

import 'dragdrop_api.dart';
import 'menu_api.dart';
import 'stage_api.dart';

import 'bootstrategy_api.dart';

class MainStrategy implements BootStrategy {
  InjectorWrap _injectorWrap;
  void processPlugins(){
    
    Stage stage = _injectorWrap.getInjector().getInstance(Stage);
       
    
    Menu menu = _injectorWrap.getInjector().getInstance(Menu);

    
    DragDrop dragdrop = _injectorWrap.getInjector().getInstance(DragDrop);
    
    

    
    dragdrop.setStage(stage);
    
    menu.setDragDrop(dragdrop);
    menu.setStage(stage);
    
    menu.start();
    dragdrop.start();
    
  }
  void setRegistry(InjectorWrap injectorWrap){
    _injectorWrap = injectorWrap;
  }
  int getPriority(){ return 0;}
  
}

