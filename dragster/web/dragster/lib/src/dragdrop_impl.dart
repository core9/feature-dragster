library dragdrop_impl;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;
import "package:dice/dice.dart";




import '../dragdrop_api.dart';
import '../grid_api.dart';
import '../highlight_api.dart';
import '../stage_api.dart';




import '../utils.dart';

class DragDropImpl extends DragDrop {

  Element _dragSourceEl;
  Stage _stage;
  @inject
  Grid _grid;
  @inject
  HighLight _highLight;

  void setStage(Stage stage){
    _stage = stage;
  }


  void start() {
    _highLight.initHighlight();
    _grid.start();
    _getWidgetsAndElements();
    initDragAndDrop(_highLight);
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
    _stage.getGridElements().forEach((e) => addEventsToColumn(e, _highLight));
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



  void _onDataLoaded(String responseText) {

    var html = parse(responseText).querySelector('body');
    var contentDivs = html.querySelectorAll('.content');

    UListElement ul = document.querySelector('#all-widgets');

    for (var div in contentDivs) {
      String widget = div.attributes['data-widget'];

      _stage.getMenu().addWidgetToMenu(ul, widget);

      _stage.addWidgetToStageAsTemplate(widget, div);

      for (Element item in _stage.getGridElements()) {
        try {
          if (item.children.first.attributes['data-widget'] == widget) {
            item.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
          }
        } catch (exception, stackTrace) {
        }
      }
    }

    _stage.getMenu().menuAddAllElementTemplates();
  }




  void _onDoubleClickResize(MouseEvent event) {
    Element element = event.target;
    document.querySelectorAll('.highlight').forEach((e) => _highLight.resetOnMouseOver(e));
    _stage.setResizeOnColumn(element);
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

    for (var col in _stage.getGridElements()) {
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