library stage;

import 'dart:html';

abstract class Executer {
  void run();
}

abstract class PreExecuter extends Executer {
  void run();
}




abstract class Stage extends PreExecuter {
  
  Element getStage();
  
  void start();
}
