library main;

import 'dragdrop_api.dart';
import 'menu_api.dart';
import 'stage_api.dart';
import 'grid_api.dart';
import 'highlight_api.dart';

import 'bootstrategy_api.dart';

class MainStrategy implements BootStrategy {
  InjectorWrap _injectorWrap;
  void processPlugins(){
    
    Stage _stage = _injectorWrap.getInjector().getInstance(Stage);
       
    
    Menu _menu = _injectorWrap.getInjector().getInstance(Menu);

    
    DragDrop dragdrop = _injectorWrap.getInjector().getInstance(DragDrop);
    
    Grid _grid = _injectorWrap.getInjector().getInstance(Grid);
    _grid.start();

    HighLight _highLight = _injectorWrap.getInjector().getInstance(HighLight);
    _highLight.setStage(_stage);
    _highLight.initHighlight();
    
    dragdrop.setStage(_stage);
    dragdrop.setHighLight(_highLight);
    
    _menu.setDragDrop(dragdrop);
    _menu.setHighLight(_highLight);
    _menu.setStage(_stage);
    
    _menu.start();
    dragdrop.start();
    
  }
  void setRegistry(InjectorWrap injectorWrap){
    _injectorWrap = injectorWrap;
  }
  int getPriority(){ return 0;}
  
}

