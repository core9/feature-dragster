library stage;

import 'dart:html';
import 'menu_api.dart';





abstract class Stage {
  
  void setMenu(Menu menu);
  Menu getMenu();
  Element getStage();
  List<Element> getAllElements();
  List<Element> getGridElements();
  void addWidgetToStageAsTemplate(String widget, var div);
  void resizeStage(String size);
  void setResizeOnColumn(Element currentElement);
}
