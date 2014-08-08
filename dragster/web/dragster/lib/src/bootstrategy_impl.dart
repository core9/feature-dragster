
import "package:dice/dice.dart";
import 'dart:mirrors';

import '../bootstrategy_api.dart';




class BootstrapFrameworkImpl implements BootstrapFramework {
  
  Injector _injector;
  List<Registry> _moduleRegistry = new List();
  List<Type> _typeRegistry = new List();
  List<BootStrategy> _bootStrategyRegistry = new List();
  
  InjectorWrap _injectorWrap = new InjectorWrap();
  
  
  void addModule(Registry module){
    _moduleRegistry.add(module);
    _typeRegistry.addAll(module.getRegistry());
   module.getRegistry().forEach((e) => print(e));
  }
  
  void run(){
    _injector = new Injector.fromModules(_moduleRegistry);
    _injectorWrap.setInjector(_injector);
    _injectorWrap.setTypeRegistry(_typeRegistry);
    _typeRegistry.forEach((e) => _collectAllBootStrategies(e));
  }

  void _collectAllBootStrategies(Type type){
      
    if(_isSubTypeOf(type, BootStrategy)){
      BootStrategy bootStrategy = _injector.getInstance(type);
      bootStrategy.setRegistry(_injectorWrap);
      bootStrategy.processPlugins();
    }
  }
  
  bool _isSubTypeOf(Type subType, Type type){
    if(reflectType(subType).isSubtypeOf(reflectType(type)))return true;
    return false;
  }
}