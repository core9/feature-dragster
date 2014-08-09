library highlight;

import 'dart:html';


abstract class HighLight {
  void start();
  void initHighlight();
  void activateHighLight(Element e);
  void resetOnMouseOver(Element element);
  List<Element> getHighLightedElements();
}
