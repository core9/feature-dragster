library dragdrop_impl;

import 'dart:html';
//import "package:dice/dice.dart";

import '../dragdrop_api.dart';
import '../highlight_api.dart';
import '../stage_api.dart';

import '../utils.dart';

class DragDropImpl extends DragDrop {

  Element _dragSourceEl;
  Stage _stage;
  HighLight _highLight;

  void setStage(Stage stage) {
    _stage = stage;
  }

  void setHighLight(HighLight highLight) {
    _highLight = highLight;
  }

  void start() {
    _stage.getWidgetsAndElements();
    initDragAndDrop(_highLight);
  }

  void initDragAndDrop(HighLight _highLight) {
    _stage.getGridElements().forEach((e) => addEventsToColumn(e, _highLight));
  }
  void addEventsToColumn(Element col, HighLight _highLight) {
    col.onDragStart.listen(_onDragStart);
    col.onDragEnd.listen((e) => _onDragEnd(e, _highLight));
    col.onDragEnter.listen(_onDragEnter);
    col.onDragOver.listen(_onDragOver);
    col.onDragLeave.listen(_onDragLeave);
    col.onDrop.listen((e) => _onDrop(e, _highLight));
    col.onDoubleClick.listen(_onDoubleClickResize);
  }

  void _onDoubleClickResize(MouseEvent event) {
    _highLight.getHighLightedElements().forEach((e) => _highLight.resetOnMouseOver(e));
    _stage.setResizeOnColumn(event.target);
  }

  void _onDragStart(MouseEvent event) {
    for (var content in _stage.getContentElements()) {
      content.classes.add(_stage.getHideClass().trim().split('.')[1]);
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
      return null;
    }
    return target;
  }

  void _onDragEnd(MouseEvent event, HighLight _highLight) {
    Element dragTarget = _getDragTarget(event);
    if (dragTarget != null) {
      dragTarget.classes.remove('moving');
      Element targetContent = dragTarget.querySelector(_stage.getContentClass());
      _highLight.resetOnMouseOver(targetContent);
    }

    for (var col in _stage.getGridElements()) {
      col.classes.remove('over');
    }

    for (Element content in _stage.getContentElements()) {
      content.classes.remove(_stage.getHideClass().trim().split('.')[1]);
      content.style.setProperty('width', '100%');
      content.style.setProperty('height', '100%');
    }
  }

  void _onDragEnter(MouseEvent event) {
    (event.target as Element).classes.add('over');
  }

  void _onDragOver(MouseEvent event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    (event.target as Element).classes.remove('over');
  }

  void _onDrop(MouseEvent event, HighLight _highLight) {
    event.stopPropagation();
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      _dragSourceEl.style.setProperty('overflow', 'visible');

      Element container;
      try {
        container = dropTarget.children.first;
      } catch (e) {
        return;
      }

      if (_dragSourceEl.parent != null && _dragSourceEl.tagName == 'IMG') {

        if (!_dragSourceEl.parent.classes.contains('content')) {
          DivElement div = new DivElement();
          div.classes.add('content');
          div.style.setProperty('display', 'block');
          div.style.setProperty('height', '100%');
          div.style.setProperty('width', '100%');
          div.style.setProperty('background-color', '#fff');
          div.style.setProperty('position', 'static');
          div.style.setProperty('overflow', 'hidden');
          _dragSourceEl.style.setProperty('height', '100%');
          _dragSourceEl.style.setProperty('width', '100%');
          _dragSourceEl.style.setProperty('margin-top', '0px');
          div.setInnerHtml(_dragSourceEl.outerHtml, treeSanitizer: new NullTreeSanitizer());
          dropTarget.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
          _highLight.getHighLightedElements().forEach((e) => _highLight.resetOnMouseOver(e));
          initDragAndDrop(_highLight);
        }

      }
try{
      if (container.tagName == 'DIV' && container.className.startsWith(_stage.getContentClass().split('.')[1])) {

        _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
        dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
        _highLight.getHighLightedElements().forEach((e) => _highLight.resetOnMouseOver(e));

      }

}catch(e){}
    }

  }

}
