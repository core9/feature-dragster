import 'dart:html';
import 'package:html5lib/parser.dart' show parse;

import 'dart:js';
import "package:json_object/json_object.dart";

import 'lib/menu.dart';
import 'lib/nedb.dart';

abstract class Dragster {
  void start();
  void resizeScreen(String strSize);
}

class DragsterImpl implements Dragster {
  Element _dragSourceEl;
  Element _columns = document.querySelector('#columns');
  List<Element> _columItems = document.querySelectorAll('#columns .column');
  Menu _menu;

  void start() {

    _menu = new MenuImpl();
    _menu.start();
    _getWidgetsAndElements();
    _initDragAndDrop();
    _setupDb();

  }

  void _getWidgetsAndElements() {
    var dataSource = _columns.dataset['source'];
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);

  }

  void _initDragAndDrop() {
    for (var col in _columItems) {
      col.onDragStart.listen(_onDragStart);
      col.onDragEnd.listen(_onDragEnd);
      col.onDragEnter.listen(_onDragEnter);
      col.onDragOver.listen(_onDragOver);
      col.onDragLeave.listen(_onDragLeave);
      col.onDrop.listen(_onDrop);
      col.onDoubleClick.listen(_onClickResize);
    }
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

    for (var div in contentDivs) {
      String widget = div.attributes['data-widget']; // add to widget list
      for (Element item in _columItems) {
        try {
          if (item.children.first.attributes['data-widget'] == widget) {
            item.setInnerHtml(div.outerHtml, treeSanitizer: new NullTreeSanitizer());
          }
        } catch (exception, stackTrace) {
        }
      }
    }
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

  void _onClickResize(MouseEvent event) {
    _setResizeOnColumn(event.target);
  }

  void _setResizeOnColumn(Element currentElement) {
    if (currentElement.className == "column") {
      currentElement.style.setProperty('overflow', 'auto');
    } else {
      _setResizeOnColumn(currentElement.parent);
    }
  }

  void _onDragStart(MouseEvent event) {

    var contentItems = document.querySelectorAll('.content');
    for (var content in contentItems) {
      content.classes.add('hide');
    }
    Element dragTarget = event.target;
    dragTarget.style.setProperty('overflow', 'visible');
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/html', dragTarget.innerHtml);
  }

  void _onDragEnd(MouseEvent event) {
    Element dragTarget = event.target;
    dragTarget.classes.remove('moving');
    var cols = document.querySelectorAll('#columns .column');
    for (var col in cols) {
      col.classes.remove('over');
    }
    var contentItems = document.querySelectorAll('.content');
    for (var content in contentItems) {
      content.classes.remove('hide');
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
      Element container = dropTarget.children.first;
      if (container.tagName == 'DIV' && container.className.startsWith('content')) {
        _dragSourceEl.setInnerHtml(dropTarget.innerHtml, treeSanitizer: new NullTreeSanitizer());
        dropTarget.setInnerHtml(event.dataTransfer.getData('text/html'), treeSanitizer: new NullTreeSanitizer());
      }

    }
  }
}

void main() {
  Dragster dragster = new DragsterImpl();
  dragster.start();
}

class NullNodeValidator implements NodeValidator {
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }
  bool allowsElement(Element element) {
    return true;
  }
}

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}
