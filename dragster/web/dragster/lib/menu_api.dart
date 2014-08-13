library menu;

import 'dart:html';
import 'dragdrop_api.dart';
import 'stage_api.dart';
import 'highlight_api.dart';
import 'db_api.dart';
import 'select_api.dart';

abstract class Menu {
  void start();
  void menuAddAllElementTemplates();
  void setDragDrop(DragDrop dragdrop);
  void setStage(Stage stage);
  void addWidgetToMenu(UListElement ul, String widget);
  void setHighLight(HighLight highLight);
  void setDB(DB db);
  void setSelect(Select select);
}
