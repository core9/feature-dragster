
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

  var injector = new Injector(new Dragster());  
  DragDrop dragdrop = injector.getInstance(DragDrop);
  
  print('pause');
  
  dragdrop.start();

}


class Dragster extends Module {
  configure() {
    register(HighLight).toInstance(new HighLightImpl());
    register(DragDrop).toInstance(new DragDropImpl());
    register(Grid).toInstance(new GridImpl());
    register(Menu).toInstance(new MenuImpl());
    register(Stage).toInstance(new StageImpl());
  }
}


