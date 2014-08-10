library dragdrop;

import 'dart:html';

import 'highlight_api.dart';
import 'stage_api.dart';


abstract class DragDrop {
  void start();
  void initDragAndDrop(HighLight _highLight);
  void addEventsToColumn(Element col , HighLight _highLight);
  void setStage(Stage stage);
  void setHighLight(HighLight highLight);
}

