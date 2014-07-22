import 'dart:html';
import 'package:html5lib/parser.dart' show parse;
import 'dart:convert';
import 'dart:js';
import "package:json_object/json_object.dart";

import 'lib/menu.dart';
import 'lib/nedb.dart';

class Basics {
  Element _dragSourceEl;
  Element _columns = document.querySelector('#columns');
  List<Element> _columItems = document.querySelectorAll('#columns .column');
  Element _showMenuElement = document.querySelector('#show-menu');
  Element _pageSelector = document.querySelector('#page-selector');
  Element _menuSecondary = document.querySelector('#navigation-secondary');



  String _apiBaseUrl = 'http://localhost:9090/api/dragster';

  Element _menuHostnameJsonDatalist = document.getElementById('menu-hostname-json-datalist');
  Element _menuHostname = document.getElementById('menu-hostname');
  Element _menuPageJsonDatalist = document.getElementById('menu-page-json-datalist');
  Element _menuPageJson = document.getElementById('menu-page');
  Element _menuVersionJsonDatalist = document.getElementById('menu-version-json-datalist');
  Element _menuVersion = document.getElementById('menu-version');
  Element _menuStatusJsonDatalist = document.getElementById('menu-status-json-datalist');
  Element _menuStatus = document.getElementById('menu-status');
  Element _menuDisplayJsonDatalist = document.getElementById('menu-display-json-datalist');
  Element _menuDisplay = document.getElementById('menu-display');
  Element _menuUseragentJsonDatalist = document.getElementById('menu-useragent-json-datalist');
  Element _menuUseragent = document.getElementById('menu-useragent');
  Element _menuPeriodJsonDatalist = document.getElementById('menu-period-json-datalist');
  Element _menuPeriod = document.getElementById('menu-period');
  Element _menuPercentageJsonDatalist = document.getElementById('menu-percentage-json-datalist');
  Element _menuPercentage = document.getElementById('menu-percentage');
  List<Element> _menuInputItems = new List(8);




  void _start() {

    Widget tmpWidget = new WidgetImpl();
    
    var dataSource = _columns.dataset['source'];
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);

    _showMenuElement.onClick.listen(_showMenu);
    _redrawTop('#columns', '#menu');

    _menuInputItems[0] = _menuHostname;
    _menuInputItems[1] = _menuPageJson;
    _menuInputItems[2] = _menuVersion;
    _menuInputItems[3] = _menuStatus;
    _menuInputItems[4] = _menuDisplay;
    _menuInputItems[5] = _menuUseragent;
    _menuInputItems[6] = _menuPeriod;
    _menuInputItems[7] = _menuPercentage;

    for (var item in _menuInputItems) {
      item.onInput.listen(_onInputMenuChange);
    }

    var menuItems = document.querySelector('#menu').children;
    for (var item in menuItems) {
      item.onClick.listen(_onClickMenuItem);
    }

    _fillMenuInputItems(_menuHostnameJsonDatalist, "/dragster/html/data/hostnames.json");
    _fillMenuInputItems(_menuPageJsonDatalist, "/dragster/html/data/pages.json");
    _fillMenuInputItems(_menuVersionJsonDatalist, "/dragster/html/data/versions.json");
    _fillMenuInputItems(_menuStatusJsonDatalist, "/dragster/html/data/status.json");
    _fillMenuInputItems(_menuDisplayJsonDatalist, "/dragster/html/data/displays.json");
    _fillMenuInputItems(_menuUseragentJsonDatalist, "/dragster/html/data/useragents.json");
    _fillMenuInputItems(_menuPeriodJsonDatalist, "/dragster/html/data/periods.json");
    _fillMenuInputItems(_menuPercentageJsonDatalist, "/dragster/html/data/percentages.json");





    for (var col in _columItems) {
      col.onDragStart.listen(_onDragStart);
      col.onDragEnd.listen(_onDragEnd);
      col.onDragEnter.listen(_onDragEnter);
      col.onDragOver.listen(_onDragOver);
      col.onDragLeave.listen(_onDragLeave);
      col.onDrop.listen(_onDrop);
      col.onDoubleClick.listen(_onClickResize);
    }

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

  void _showMenu(Event event) {
    Element menuButton = event.target;
    _pageSelector.classes.toggle('display-none');
    _menuSecondary.classes.toggle('display-none');
    _redrawTop('#columns', '#menu');
  }

  void _redrawTop(String target, String source) {
    String height = (document.querySelector(source).borderEdge.height + 30).toString() + 'px';
    document.querySelector(target).style.setProperty('top', height);
  }

  void _onInputMenuChange(Event event) {
    InputElement inputBox = event.target;
    switch (inputBox.id) {
      case 'menu-display':
        _resizeScreen(inputBox.value);
        break;
      case 'menu-version':
        break;
    }
    print(inputBox.value);
  }

  void _fillMenuInputItems(Element optionList, String jsonSourceUrl) {

    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        List parsedList = JSON.decode(request.responseText);
        for (var value in parsedList) {
          Element option = document.createElement('option');
          option.setAttribute('value', value);
          optionList.append(option);
        }

      }
    });

    var data = {
      "id": "QHL2NIOYKGU1",
      "host": {
        "id": "2",
        "name": null
      },
      "name": null,
      "versions": [],
      "currentVersion": {
        "id": "2",

        "name": null
      },
      "status": "available",
      "html": null
    };

    request.open("GET", jsonSourceUrl, async: false);
    request.send(data.toString());

  }

  void _attachDataList(String responseText, Element optionList) {

    List parsedList = JSON.decode(responseText);
    for (var value in parsedList) {
      Element option = document.createElement('option');
      option.setAttribute('value', value);
      optionList.append(option);
    }
  }

  void _onClickMenuItem(MouseEvent event) {
    Element menuTarget = event.target;
    switch (menuTarget.innerHtml.trim().toLowerCase()) {
      case '320':
        _resizeScreen('320');
        break;
      case '640':
        _resizeScreen('640');
        break;
      case '768':
        _resizeScreen('768');
        break;
      case '960':
        _resizeScreen('960');
        break;
      case '1280':
        _resizeScreen('1280');
        break;
      case 'load':
        _load();
        break;
      case 'save':
        _save();
        break;
    }

  }

  void _load() {
    print('load');
  }

  void _save() {

    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        print(request.responseText); // output the response from the server
      }
    });

    var data = {
      "id": "QHL2NIOYKGU1",
      "host": {
        "id": "2",
        "name": null
      },
      "name": null,
      "versions": [],
      "currentVersion": {
        "id": "2",

        "name": null
      },
      "status": "available",
      "html": null
    };

    var url = "http://localhost:9090/api/dragster";
    request.open("POST", url, async: false);
    request.send(data.toString());


  }

  void _resizeScreen(String strSize) {
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
  var basics = new Basics();
  basics._start();
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
