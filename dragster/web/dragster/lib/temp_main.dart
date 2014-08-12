library main;

import 'dragdrop_api.dart';
import 'menu_api.dart';
import 'stage_api.dart';
import 'grid_api.dart';
import 'highlight_api.dart';
import 'select_api.dart';
import 'dndfiles.dart';

import 'bootstrategy_api.dart';

class MainStrategy implements BootStrategy {
  InjectorWrap _injectorWrap;
  void processPlugins(){
    
    Stage _stage = _injectorWrap.getInjector().getInstance(Stage);
    Menu _menu = _injectorWrap.getInjector().getInstance(Menu);
    DragDrop _dragdrop = _injectorWrap.getInjector().getInstance(DragDrop);
    Grid _grid = _injectorWrap.getInjector().getInstance(Grid);
    HighLight _highLight = _injectorWrap.getInjector().getInstance(HighLight);
    Select _select = _injectorWrap.getInjector().getInstance(Select);
    
    _select.setStage(_stage);
    _select.start();
    
    _grid.start();
    
    _highLight.setStage(_stage);
    _highLight.initHighlight();
    
    _dragdrop.setStage(_stage);
    _dragdrop.setHighLight(_highLight);
    _dragdrop.start();

    
    _menu.setDragDrop(_dragdrop);
    _menu.setHighLight(_highLight);
    _menu.setStage(_stage);
    _menu.start();
    
    DndFiles upload = new DndFiles();
    upload.setHighLight(_highLight);
    upload.setDragDrop(_dragdrop);
    
  }
  void setRegistry(InjectorWrap injectorWrap){
    _injectorWrap = injectorWrap;
  }
  int getPriority(){ return 0;}
  
}

