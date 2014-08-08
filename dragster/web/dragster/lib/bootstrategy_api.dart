library bootstrategy;

import "package:dice/dice.dart";



abstract class BootstrapFramework {
  void addModule(Module module);
  void run();
}



abstract class BootStrategy {


  /**
   * Processes all plugins
   */
  void processPlugins();

  /**
   * Set the plugin registry
   */
  void setRegistry(List registry);
  
  /**
   * Return the Plugin priority
   * @return Integer
   */
  int getPriority();

}


abstract class BootstrapStrategies {
  void bootstrap();
  Map<int, List<BootStrategy>> getStrategies();
  void setRegistry(List registry);
}

