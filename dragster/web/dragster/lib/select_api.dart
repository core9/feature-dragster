library select;


import 'dart:html';

import 'stage_api.dart';
import 'highlight_api.dart';

abstract class Select {
  void start();
  void initSelect();
  void activateSelect(Element e);
  List<Element> getSelectedElements();
  void setStage(Stage stage);
  void removeAllSelections();
  void setHighLight(HighLight highLight);

}