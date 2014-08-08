
import "package:dice/dice.dart";
import 'dart:html';
import 'dart:mirrors';

import 'lib/bootstrategy_api.dart';
import 'lib/src/bootstrategy_impl.dart';

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
  


  module.getRegistry().forEach((e) => printInterfacesOfType(e));
  
  BootstrapFramework bootstrap = new BootstrapFrameworkImpl();
  bootstrap.addModule(module);
  bootstrap.run();
  
}

void printInterfacesOfType(Type type){
  print(type);
  TypeMirror tp = reflectType(type);
  TypeMirror subType = reflectType(Executer);
  
  if(tp.isSubtypeOf(subType)){
    print('is sub type of : ' + subType.toString());
  }

  print(tp);
  
}



class Dragster extends Module {
  // add by mixin
  List<Type> _registry = new List();
  
  List<Type> getRegistry(){
    return _registry;
  }
  
  void registerToInstance(Type type, dynamic obj){
    _registry.add(type);
    register(type).toInstance(obj);
  }
  
  configure() {
  }
}


