library dragdrop;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;

import 'dart:js';
import "package:json_object/json_object.dart";
import 'dart:convert';

import 'menu.dart';
import 'nedb.dart';
import 'grid.dart';
import 'utils.dart';

abstract class DragDrop {
  void start();
  void resizeScreen(String strSize);
  void initDragAndDrop();
  void addEventsToColumn(Element col);
  void initHighlight();
  void activateHighLight(Element e);
}

class DragDropImpl extends DragDrop {

  Element _dragSourceEl;
  Element _columns = document.querySelector('#columns');
  List<Element> _columnsElements = document.querySelectorAll('#columns');
  List<Element> _columItems = document.querySelectorAll('#columns .column');
  Menu _menu;



  void start() {

    Grid grid = new GridImpl();
    grid.start();
    _menu = new MenuImpl();
    _menu.start();
    _getWidgetsAndElements();
    initDragAndDrop();
    _setupDb();
    initHighlight();
    
    _isSelected();

  }
  
  void _isSelected(){
    //_columnsElements.forEach((e) => e.onClick.listen(_selected));
  }

  void _selected(MouseEvent event){
    Element element = event.target;

    if(element.classes.contains('selected')){
      print('removing selected');
      element.classes.remove('selected');
      int width = element.clientWidth;
      int height = element.clientHeight;
      element.style.setProperty('width', (width + 4).toString() + 'px');
      element.style.setProperty('height', (height + 4).toString() + 'px');
    }else{
      element.classes.add('selected');
      print('adding selected');
    }
    print('selected : ');
    print(element.toString());
  }
  
  
  void initHighlight() {
    _columnsElements.forEach((e) => activateHighLight(e));
  }

  void activateHighLight(Element e) {
    e.onMouseOver.listen(_highLightOnMouseOver);
    e.onMouseOut.listen(_highLightOnMouseOut);
  }


  Element _getFirstParentWithClass(Element element, String className){
    if(element == null) return null;
    Element parent = element.parent;
    if(parent != null){
      if(parent.classes.contains(className)) return parent;
    }
    return _getFirstParentWithClass(parent, className);
  }

  void _highLightOnMouseOver(MouseEvent event) {
    Element element = event.target;
    if (element == null) return;
    if (element.id == 'columns') return;
    if (element.classes.contains('resize')) return;
    
    String border = element.style.border;
     int width = element.clientWidth;
     int height = element.clientHeight;
     var mapData = new Map();
     var cssData = new Map();
     cssData["border"] = border;
     cssData["width"] = width.toString() + 'px';
     cssData["height"] = height.toString() + 'px';
     mapData["properties"] = new List();
     mapData["properties"].add(cssData);
     String jsonData = JSON.encode(mapData);
     document.querySelector('#hover-placeholder').text = jsonData;
     element.style.setProperty('width', (width - 4).toString() + 'px');
     element.style.setProperty('height', (height - 4).toString() + 'px');
     element.style.setProperty('border', '2px solid lightblue');
     element.classes.add('highlight');
  }

  void _highLightOnMouseOut(MouseEvent event) {
    Element element = event.target;
    _resetOnMouseOver(element);
  }

  void _resetOnMouseOver(Element element) {
    if (element == null) return;
    if (element.id == 'columns') return;
    if (element.classes.contains('resize')) return;
    print('mouse leave');
    String properties = document.querySelector('#hover-placeholder').text;
    if (properties == '') return;
    var json = JSON.decode(properties);
    List<Map> cssProperties = json['properties'];
    cssProperties.forEach((e) => _setProperties(element, e));
    element.classes.remove('highlight');
  }

  void _setProperties(Element element, Map e) {
    e.keys.forEach((key) => element.style.setProperty(key, e[key]));
  }

  void _getWidgetsAndElements() {
    var dataSource = _columns.dataset['source'];
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);

  }

  void initDragAndDrop() {
    document.querySelectorAll('#columns .column').forEach((e) => addEventsToColumn(e));
  }
  void addEventsToColumn(Element col) {
    col.onDragStart.listen(_onDragStart);
    col.onDragEnd.listen(_onDragEnd);
    col.onDragEnter.listen(_onDragEnter);
    col.onDragOver.listen(_onDragOver);
    col.onDragLeave.listen(_onDragLeave);
    col.onDrop.listen(_onDrop);
    col.onDoubleClick.listen(_onDoubleClickResize);
  }

  void _setupDb() {
    Nedb nedb = new Nedb();
    JsObject db = nedb.getDb();
    var data = new JsonObject();
    data.language = "Dart";
    data.targets = new List();
    data.targets.add("Dartium");
    db.callMethod('insert', [data]);
    var crit = new JsonObject();
    crit.language = "Dart";
    db.callMethod('count', [crit, _calb]);
  }

  void _onDataLoaded(String responseText) {

    var html = parse(responseText).querySelector('body');
    var contentDivs = html.querySelectorAll('.content');

    UListElement ul = document.querySelector('#all-widgets');

    for (var div in contentDivs) {
      String widget = div.attributes['data-widget'];

      _addWidgetToMenu(ul, widget);

      _addWidgetToStageAsTemplate(widget, div);

      for (Element item in _columItems) {
        try {
          if (item.children.first.attributes['data-widget'] == widget) {
            item.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
          }
        } catch (exception, stackTrace) {
        }
      }
    }

    Menu menu = new MenuImpl();
    menu.menuAddAllElementTemplates();
  }

  void _addWidgetToStageAsTemplate(String widget, var div) {
    print(div);
    TemplateElement template = new TemplateElement();
    template.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
    template.setAttribute('id', widget);
    Element widgetPlaceholder = document.querySelector('#widget-placeholder');
    widgetPlaceholder.append(template);
  }


  void _addWidgetToMenu(UListElement ul, String widget) {
    print(widget);
    List<String> classes = [];
    classes.add('menu');
    classes.add('widget-element');
    LIElement li = new LIElement();
    AnchorElement link = new AnchorElement();
    link.classes.addAll(classes);
    link.setAttribute('href', '#' + widget);
    link.text = widget;
    li.append(link);
    ul.append(li);
  }

  void _calb(err, count) {
    print("Number of items found : " + count.toString());
  }

  void resizeScreen(String strSize) {
    int intSize = int.parse(strSize);
    _columns.style.setProperty('position', 'relative');
    _columns.style.setProperty('left', '50%');
    _columns.style.setProperty('width', '${strSize}px');
    _columns.style.setProperty('margin-left', '-${intSize / 2}px');
  }

  void _onDoubleClickResize(MouseEvent event) {
    Element element = event.target;
    document.querySelectorAll('.highlight').forEach((e) => _resetOnMouseOver(e));
    _setResizeOnColumn(element);
 }

  void _setResizeOnColumn(Element currentElement) {
    if (currentElement == null) return;
    if (currentElement.classes.contains('column')) {
      if (currentElement.classes.contains('resize')) {
       
        
        currentElement.classes.remove('resize');
        currentElement.style.setProperty('overflow', 'visible');
        Element content = currentElement.querySelector('.content');
        _resetOnMouseOver(content);
        content.style.setProperty('width', '100%');
        content.style.setProperty('height', '100%');
        document.querySelector('#hover-placeholder').text = "";
      } else {
        currentElement.style.setProperty('overflow', 'auto');

        
        currentElement.classes.add('resize');
        Element content = currentElement.querySelector('.content');
        content.style.setProperty('width', '50%');
        content.style.setProperty('height', '50%');
      }
    } else {
      _setResizeOnColumn(currentElement.parent);
    }
  }


  void _onDragStart(MouseEvent event) {

    var contentItems = document.querySelectorAll('.content');
    for (var content in contentItems) {
      content.classes.add('hide');
    }
    Element dragTarget = _getDragTarget(event);
    if (dragTarget == null) {
      return;
    }
    dragTarget.style.setProperty('overflow', 'visible');
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/html', dragTarget.innerHtml);
  }

  Element _getDragTarget(MouseEvent event) {
    Element target;
    if (event.target is Element && (event.target as Element).draggable) {
      target = event.target;
    } else {
      return null;//_getDragTarget(event); // go get first draggable parent
    }

    return target;
  }



  void _onDragEnd(MouseEvent event) {
    Element dragTarget = _getDragTarget(event);
    if (dragTarget != null) {
      dragTarget.classes.remove('moving');
      Element targetContent = dragTarget.querySelector('.content');
      _resetOnMouseOver(targetContent);
    }
    var cols = document.querySelectorAll('#columns .column');
    for (var col in cols) {
      col.classes.remove('over');
    }
    List<Element> contentItems = document.querySelectorAll('.content');
    for (Element content in contentItems) {
      content.classes.remove('hide');
      content.style.setProperty('width', '100%');
      content.style.setProperty('height', '100%');
    }
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.add('over');
  }

  void _onDragOver(MouseEvent event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.remove('over');
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      _dragSourceEl.style.setProperty('overflow', 'visible');
      
      Element container;
      try{
        container = dropTarget.children.first;
      }catch(e){
        return;
      }
      
      if (container.tagName == 'DIV' && container.className.startsWith('content')) {
        _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
        dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
        document.querySelectorAll('.highlight').forEach((e) => _resetOnMouseOver(e));

      }

    }



  }

}
