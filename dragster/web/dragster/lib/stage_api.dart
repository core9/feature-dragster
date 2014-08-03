library stage;

abstract class Executer {
  void run();
}

abstract class PreExecuter extends Executer {
  void run();
}




abstract class Stage extends PreExecuter {
  void start();
}
