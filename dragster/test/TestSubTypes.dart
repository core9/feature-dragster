
import 'dart:html';
import 'dart:mirrors';

import '../web/dragster/lib/bootstrategy_api.dart';

import '../web/dragster/lib/dragdrop_api.dart';
import '../web/dragster/lib/src/dragdrop_impl.dart';
import '../web/dragster/lib/highlight_api.dart';
import '../web/dragster/lib/src/highlight_impl.dart';
import '../web/dragster/lib/menu_api.dart';
import '../web/dragster/lib/src/menu_impl.dart';
import '../web/dragster/lib/grid_api.dart';
import '../web/dragster/lib/stage_api.dart';
import '../web/dragster/lib/src/stage_impl.dart';

List<Element> _columnsElements = document.querySelectorAll('#columns');

void main() {

  Registry module = new Registry();
  module.registerToInstance(HighLight, new HighLightImpl());
  module.registerToInstance(DragDrop, new DragDropImpl());
  module.registerToInstance(Grid, new GridImpl());
  module.registerToInstance(Menu, new MenuImpl());
  module.registerToInstance(Stage, new StageImpl());
  


  module.getRegistry().forEach((e) => printInterfacesOfType(e));
  

  
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





