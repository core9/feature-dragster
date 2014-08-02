
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
  dragdrop.start();

}


class Dragster extends Module {
  configure() {
    register(HighLight).toType(HighLightImpl);
    register(DragDrop).toType(DragDropImpl);
    register(Grid).toType(GridImpl);
    register(Menu).toType(MenuImpl);
    register(Stage).toType(StageImpl);
  }
}


