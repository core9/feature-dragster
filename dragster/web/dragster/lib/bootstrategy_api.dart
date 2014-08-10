library bootstrategy;



import "package:dice/dice.dart";

class InjectorWrap {
    Injector _injector;
    List<Type> _typeRegistry;
    
    Injector getInjector(){
      return _injector;
    }
    
    void setInjector(Injector injector){
      _injector = injector;
    }
    
    List<Type> getTypeRegistry(){
      return _typeRegistry;
    }
    
    void setTypeRegistry(List<Type> typeRegistry){
      _typeRegistry = typeRegistry;
    }
}

abstract class BootstrapFramework {
  void addModule(Module module);
  void run();
}

class Registry extends Module {

  List<Type> _registry = new List();  
  List<Type> getRegistry(){
    return _registry;
  }
  
  void registerToInstance(Type type, dynamic obj){
    _registry.add(type);
    register(type).toInstance(obj);
  }
  
  configure() {
  }
  
}





abstract class BootStrategy {

  void processPlugins();
  void setRegistry(InjectorWrap injectorWrap);
  int getPriority();

}

class InstBootStrategy extends BootStrategy {
  void processPlugins(){}
  void setRegistry(InjectorWrap injectorWrap){}
  int getPriority(){
    return 0;
  }
}


abstract class BootstrapStrategies {
  void bootstrap();
  Map<int, List<BootStrategy>> getStrategies();
  void setRegistry(List registry);
}

