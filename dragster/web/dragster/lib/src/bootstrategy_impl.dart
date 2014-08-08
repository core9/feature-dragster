
import "package:dice/dice.dart";

import '../bootstrategy_api.dart';
import '../dragdrop_api.dart';



class BootstrapFrameworkImpl implements BootstrapFramework {
  
  Injector injector;
  
  
  void addModule(Module module){
    
   injector = new Injector(module);  

    
  }
  void run(){
    
    DragDrop dragdrop = injector.getInstance(DragDrop);
    
    
    dragdrop.start();
    
  }
}