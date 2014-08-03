
import "package:dice/dice.dart";
import 'dart:html';

import 'lib/dragdrop_api.dart';
import 'lib/src/dragdrop_impl.dart';
import 'lib/highlight_api.dart';
import 'lib/src/highlight_impl.dart';
import 'lib/menu_api.dart';
import 'lib/src/menu_impl.dart';
import 'lib/grid_api.dart';
import 'lib/stage_api.dart';
import 'lib/src/stage_impl.dart';

List<Element> _columnsElements = document.querySelectorAll('#columns');

void main() {

  var module = new Dragster();
  module.registerToInstance(HighLight, new HighLightImpl());
  module.registerToInstance(DragDrop, new DragDropImpl());
  module.registerToInstance(Grid, new GridImpl());
  module.registerToInstance(Menu, new MenuImpl());
  module.registerToInstance(Stage, new StageImpl());
  
  var injector = new Injector(module);  
  DragDrop dragdrop = injector.getInstance(DragDrop);
  
  
  dragdrop.start();

}




class Dragster extends Module {
  
  List<Type> registry = new List();
  
  
  void registerToInstance(Type type, dynamic obj){
    registry.add(type);
    register(type).toInstance(obj);
    print('added : ' + type.toString());
  }
  
  configure() {
    
    for(Type type in registry){
      print('added : ' + type.toString());
    }
    
    //register(HighLight).toInstance(new HighLightImpl());
    //register(DragDrop).toInstance(new DragDropImpl());
    //register(Grid).toInstance(new GridImpl());
    //register(Menu).toInstance(new MenuImpl());
    //register(Stage).toInstance(new StageImpl());
  }
}


