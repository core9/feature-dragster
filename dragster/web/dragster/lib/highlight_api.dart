library highlight;

import 'dart:html';

import 'stage_api.dart';

abstract class HighLight {
  void start();
  void initHighlight();
  void activateHighLight(Element e);
  void resetOnMouseOver(Element element);
  List<Element> getHighLightedElements();
  void setStage(Stage stage);

}
