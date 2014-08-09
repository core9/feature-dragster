library dragdrop_impl;

import 'dart:html';
import "package:dice/dice.dart";

import '../dragdrop_api.dart';
import '../highlight_api.dart';
import '../stage_api.dart';

import '../utils.dart';

class DragDropImpl extends DragDrop {

  Element _dragSourceEl;
  Stage _stage;
  @inject
  HighLight _highLight;

  void setStage(Stage stage) {
    _stage = stage;
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
      return null;
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

    for (Element content in _stage.getContentElements()) {
      content.classes.remove('hide');
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

      if (container.tagName == 'DIV' && container.className.startsWith('content')) {
        _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
        dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
        _highLight.getHighLightedElements().forEach((e) => _highLight.resetOnMouseOver(e));

      }

    }

  }

}
