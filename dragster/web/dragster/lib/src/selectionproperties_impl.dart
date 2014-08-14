library selectionpropertiesimpl;

import 'dart:html';
import '../selectionproperties_api.dart';


class SelectionPropertiesImpl implements SelectionProperties {
  
  
  List<Element> getAllInputFields(){
    return document.querySelectorAll('#selection-properties input');
  }
  
  
  void start(){
    print('selection properties starting');
    
    getAllInputFields().forEach((e) => _prepareFormElements(e));
    
  }
  
  void _prepareFormElements(Element element){
    
    
    print(element.tagName);
    
    element.onChange.listen(_onInputChange);
    
  }
  
  void _onInputChange(Event event){
    InputElement element = event.target;
    print('input type : ');
    print(element.type);
    print('changed propertie : ');
    print(element.name);
    print('value : ');
    print(element.value);
    
  }
  
}