library stage_impl;

import 'dart:html';

import '../stage_api.dart';
import '../menu_api.dart';
import '../utils.dart';
import 'package:html5lib/parser.dart' show parse;



class StageImpl extends Stage {

  String contentClass = '.content'; 
  String hideClass = '.hide';
  String stageId = '#columns';
  
  Menu _menu;

  String getContentClass(){
    return contentClass;
  }
  
  String getHideClass(){
    return hideClass;
  }
  
  Element getStage(){
    return document.querySelector(stageId);
  }
  
  List<Element> getAllElements(){
    return document.querySelectorAll(stageId);
  }
  
  List<Element> getGridElements(){
    return document.querySelectorAll(stageId + ' .column');
  }
 
  void setMenu(Menu menu){
    _menu = menu;
  }
  
  Menu getMenu(){
    return _menu;
  }

  List<Element> getContentElements(){
    return document.querySelectorAll(contentClass);
  }
  
  void getWidgetsAndElements() {
    var dataSource = getStage().dataset['source'];
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);

  }

  void _onDataLoaded(String responseText) {

    var html = parse(responseText).querySelector('body');
    var contentDivs = html.querySelectorAll('.content');

    UListElement ul = document.querySelector('#all-widgets');

    for (var div in contentDivs) {
      String widget = div.attributes['data-widget'];

      getMenu().addWidgetToMenu(ul, widget);

      addWidgetToStageAsTemplate(widget, div);

      for (Element item in getGridElements()) {
        try {
          if (item.children.first.attributes['data-widget'] == widget) {
            item.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
          }
        } catch (exception, stackTrace) {
        }
      }
    }

    getMenu().menuAddAllElementTemplates();
  }
  
  void addWidgetToStageAsTemplate(String widget, var div) {
    print(div);
    TemplateElement template = new TemplateElement();
    template.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
    template.setAttribute('id', widget);
    Element widgetPlaceholder = document.querySelector('#widget-placeholder');
    widgetPlaceholder.append(template);
  }
  
  void resizeStage(String strSize) {
    int intSize = int.parse(strSize);
    getStage().style.setProperty('position', 'relative');
    getStage().style.setProperty('left', '50%');
    getStage().style.setProperty('width', '${strSize}px');
    getStage().style.setProperty('margin-left', '-${intSize / 2}px');
  }
  
  void setResizeOnColumn(Element currentElement) {
    if (currentElement == null) return;
    if (currentElement.classes.contains('column')) {
      if (currentElement.classes.contains('resize')) {
        currentElement.classes.remove('resize');
        currentElement.style.setProperty('overflow', 'visible');
        Element content = currentElement.querySelector(contentClass);
        content.style.setProperty('width', '100%');
        content.style.setProperty('height', '100%');
        document.querySelector('#hover-placeholder').text = "";
      } else {
        currentElement.style.setProperty('overflow', 'auto');
        currentElement.classes.add('resize');
        Element content = currentElement.querySelector(contentClass);
        content.style.setProperty('width', '50%');
        content.style.setProperty('height', '50%');
      }
    } else {
      setResizeOnColumn(currentElement.parent);
    }
  }
  
}