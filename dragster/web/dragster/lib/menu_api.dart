library menu;

import 'dragdrop_api.dart';
import 'stage_api.dart';

abstract class Menu {
  void start();
  void menuAddAllElementTemplates();
  void setDragDrop(DragDrop dragdrop);
  void setStage(Stage stage);
}
