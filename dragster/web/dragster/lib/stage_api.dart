library stage;

import 'dart:html';
import 'menu_api.dart';

abstract class Executer {
  void run();
}

abstract class PreExecuter extends Executer {
  void run();
}




abstract class Stage extends PreExecuter {
  
  void setMenu(Menu menu);
  Menu getMenu();
  Element getStage();
  List<Element> getStageElements();
  
  void start();
}
