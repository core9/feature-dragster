library dragdrop_impl;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;
import "package:dice/dice.dart";

import 'dart:js';
import "package:json_object/json_object.dart";


import '../dragdrop_api.dart';
import '../grid_api.dart';
import '../highlight_api.dart';
import '../stage_api.dart';



import '../nedb.dart';
import '../utils.dart';

class DragDropImpl extends DragDrop {

  Element _dragSourceEl;

  List<Element> _columItems = document.querySelectorAll('#columns .column');

  
  @inject
  Stage _stage;
  @inject
  Grid _grid;
  @inject
  HighLight _highLight;

  


  void start() {
    _highLight.initHighlight();
    _grid.start();
    //_stage.getMenu().start();
    _getWidgetsAndElements();
    initDragAndDrop(_highLight);
    _setupDb();
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
  
  



  Element _getFirstParentWithClass(Element element, String className){
    if(element == null) return null;
    Element parent = element.parent;
    if(parent != null){
      if(parent.classes.contains(className)) return parent;
    }
    return _getFirstParentWithClass(parent, className);
  }



  void _getWidgetsAndElements() {
    var dataSource = _stage.getStage().dataset['source'];
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);

  }

  void initDragAndDrop(HighLight _highLight) {
    document.querySelectorAll('#columns .column').forEach((e) => addEventsToColumn(e, _highLight));
  }
  void addEventsToColumn(Element col , HighLight _highLight) {
    col.onDragStart.listen(_onDragStart);
    col.onDragEnd.listen((e) => _onDragEnd(e, _highLight));
    col.onDragEnter.listen(_onDragEnter);
    col.onDragOver.listen(_onDragOver);
    col.onDragLeave.listen(_onDragLeave);
    col.onDrop.listen((e) => _onDrop(e, _highLight));
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

    //Menu menu = new MenuImpl();
    _stage.getMenu().menuAddAllElementTemplates();
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
    _stage.getStage().style.setProperty('position', 'relative');
    _stage.getStage().style.setProperty('left', '50%');
    _stage.getStage().style.setProperty('width', '${strSize}px');
    _stage.getStage().style.setProperty('margin-left', '-${intSize / 2}px');
  }

  void _onDoubleClickResize(MouseEvent event) {
    Element element = event.target;
    document.querySelectorAll('.highlight').forEach((e) => _highLight.resetOnMouseOver(e));
    _setResizeOnColumn(element);
 }

  void _setResizeOnColumn(Element currentElement) {
    if (currentElement == null) return;
    if (currentElement.classes.contains('column')) {
      if (currentElement.classes.contains('resize')) {
       
        
        currentElement.classes.remove('resize');
        currentElement.style.setProperty('overflow', 'visible');
        Element content = currentElement.querySelector('.content');
        _highLight.resetOnMouseOver(content);
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



  void _onDragEnd(MouseEvent event, HighLight _highLight) {
    Element dragTarget = _getDragTarget(event);
    if (dragTarget != null) {
      dragTarget.classes.remove('moving');
      Element targetContent = dragTarget.querySelector('.content');
      _highLight.resetOnMouseOver(targetContent);
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

  void _onDrop(MouseEvent event, HighLight _highLight) {
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
        document.querySelectorAll('.highlight').forEach((e) => _highLight.resetOnMouseOver(e));

      }

    }



  }

}