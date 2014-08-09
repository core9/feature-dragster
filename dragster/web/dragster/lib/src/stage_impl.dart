library stage_impl;

import 'dart:html';

import '../stage_api.dart';
import '../menu_api.dart';
import '../utils.dart';


class StageImpl extends Stage {
  
  
  Menu _menu;
  
  Element getStage(){
    return document.querySelector('#columns');;
  }
  
  List<Element> getAllElements(){
    return document.querySelectorAll('#columns');
  }
  
  List<Element> getGridElements(){
    return document.querySelectorAll('#columns .column');
  }
 
  void setMenu(Menu menu){
    _menu = menu;
  }
  
  Menu getMenu(){
    return _menu;
  }
  
  void addWidgetToStageAsTemplate(String widget, var div) {
    print(div);
    TemplateElement template = new TemplateElement();
    template.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
    template.setAttribute('id', widget);
    Element widgetPlaceholder = document.querySelector('#widget-placeholder');
    widgetPlaceholder.append(template);
  }
  
}