library menu;

import 'dart:html';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:html5lib/parser.dart' show parse;
//import 'dart:indexed_db';
import 'package:lawndart/lawndart.dart';
import 'utils.dart';



import 'dragdrop.dart';

abstract class Menu {
  void start();
}

class MenuImpl extends Menu {

  Element _showMenuElement = document.querySelector('#show-menu');
  Element _pageSelector = document.querySelector('#page-selector');
  Element _menuSecondary = document.querySelector('#navigation-secondary');

  Element _menuGeoJsonDatalist = document.getElementById('menu-geo-json-datalist');
  InputElement _menuGeo = document.getElementById('menu-geo');
  Element _menuHostnameJsonDatalist = document.getElementById('menu-hostname-json-datalist');
  InputElement _menuHostname = document.getElementById('menu-hostname');
  Element _menuPageJsonDatalist = document.getElementById('menu-page-json-datalist');
  InputElement _menuPageJson = document.getElementById('menu-page');
  Element _menuVersionJsonDatalist = document.getElementById('menu-version-json-datalist');
  InputElement _menuVersion = document.getElementById('menu-version');
  Element _menuStatusJsonDatalist = document.getElementById('menu-status-json-datalist');
  InputElement _menuStatus = document.getElementById('menu-status');
  Element _menuDisplayJsonDatalist = document.getElementById('menu-display-json-datalist');
  InputElement _menuDisplay = document.getElementById('menu-display');
  Element _menuUseragentJsonDatalist = document.getElementById('menu-useragent-json-datalist');
  InputElement _menuUseragent = document.getElementById('menu-useragent');
  Element _menuPeriodJsonDatalist = document.getElementById('menu-period-json-datalist');
  InputElement _menuPeriod = document.getElementById('menu-period');
  Element _menuPercentageJsonDatalist = document.getElementById('menu-percentage-json-datalist');
  InputElement _menuPercentage = document.getElementById('menu-percentage');
  Element _menuActionJsonDatalist = document.getElementById('menu-action-json-datalist');
  InputElement _menuAction = document.getElementById('menu-action');
  Element _menuRequestJsonDatalist = document.getElementById('menu-request-json-datalist');
  InputElement _menuRequest = document.getElementById('menu-request');

  List<Element> _menuInputItems = new List(11);
  List<String> _excludeFromHash = new List(2);

  DragDrop _dragdrop;

  Element _columns = document.querySelector('#columns');

  var _db = new Store('dbName', 'storeName');

  void start() {

    _redrawTop('#columns', '#menu');
    _excludeFromHash[0] = 'menu-display';
    _excludeFromHash[1] = 'menu-action';
    _dragdrop = new DragDropImpl();
    _showMenuElement.onClick.listen(_showMenu);
    _putMenuItemsInListAndAddClickEvent();
    _ulMenuAddClickEvents();
    _menuAddOptions();
  }

  void _load() {
    String hash = _getState();
    _db.open().then((_) => _db.getByKey(hash)).then((value) {
      var innerHtml = parse(value).querySelector('#columns').innerHtml;
      _columns.children.clear();
      _columns.setInnerHtml(innerHtml, treeSanitizer: new NullTreeSanitizer());
      _dragdrop.initDragAndDrop();
    });
  }

  void _save() {
    _saveLocal();
  }

  void _saveLocal() {
    String hash = _getState();
    String html = _columns.outerHtml.toString();
    _db.open()//.then((_) => _db.nuke())
    .then((_) => _db.save(html, hash));
  }

  String _getState() {

    String hash = "";
    var re = new RegExp('/\W/g');
    for (InputElement item in _menuInputItems) {
      if (!_excludeFromHash.contains(item.id)) {
        hash += item.value.trim().toLowerCase().replaceAll(re, '').replaceAll(' ', '');
      }
    }
    var sha1 = new SHA1();
    sha1.add(hash.codeUnits);
    return CryptoUtils.bytesToHex(sha1.close());
  }

  void _saveRemote() {
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
        print(request.responseText);
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

  void _putMenuItemsInListAndAddClickEvent() {
    _menuInputItems[0] = _menuGeo;
    _menuInputItems[1] = _menuHostname;
    _menuInputItems[2] = _menuPageJson;
    _menuInputItems[3] = _menuVersion;
    _menuInputItems[4] = _menuStatus;
    _menuInputItems[5] = _menuDisplay;
    _menuInputItems[6] = _menuUseragent;
    _menuInputItems[7] = _menuPeriod;
    _menuInputItems[8] = _menuPercentage;
    _menuInputItems[9] = _menuAction;
    _menuInputItems[10] = _menuRequest;

    for (var item in _menuInputItems) {
      item.onInput.listen(_onInputMenuChange);
    }

  }

  void _ulMenuAddClickEvents() {
    var menuItems = document.querySelector('#menu').children;
    for (var item in menuItems) {
      item.onClick.listen(_onClickMenuItem);
    }
  }

  void _menuAddOptions() {
    _fillMenuInputItems(_menuGeoJsonDatalist, "/dragster/data/geo.json");
    _fillMenuInputItems(_menuHostnameJsonDatalist, "/dragster/data/hostnames.json");
    _fillMenuInputItems(_menuPageJsonDatalist, "/dragster/data/pages.json");
    _fillMenuInputItems(_menuVersionJsonDatalist, "/dragster/data/versions.json");
    _fillMenuInputItems(_menuStatusJsonDatalist, "/dragster/data/status.json");
    _fillMenuInputItems(_menuDisplayJsonDatalist, "/dragster/data/displays.json");
    _fillMenuInputItems(_menuUseragentJsonDatalist, "/dragster/data/useragents.json");
    _fillMenuInputItems(_menuPeriodJsonDatalist, "/dragster/data/periods.json");
    _fillMenuInputItems(_menuPercentageJsonDatalist, "/dragster/data/percentages.json");
    _fillMenuInputItems(_menuActionJsonDatalist, "/dragster/data/actions.json");
    _fillMenuInputItems(_menuRequestJsonDatalist, "/dragster/data/requests.json");
  }

  void _showMenu(Event event) {
    Element menuButton = event.target;
    _pageSelector.classes.toggle('display-none');
    _menuSecondary.classes.toggle('display-none');
    _redrawTop('#columns', '#menu');
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
    request.open("GET", jsonSourceUrl, async: false);
    request.send();

  }

  void _redrawTop(String target, String source) {
    String height = (document.querySelector(source).borderEdge.height + 30).toString() + 'px';
    document.querySelector(target).style.setProperty('top', height);
  }

  void _onInputMenuChange(Event event) {
    InputElement inputBox = event.target;
    switch (inputBox.id) {
      case 'menu-display':
        _dragdrop.resizeScreen(inputBox.value);
        break;
      case 'menu-version':
        break;
    }
    print(inputBox.value);
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
        _dragdrop.resizeScreen('320');
        break;
      case '640':
        _dragdrop.resizeScreen('640');
        break;
      case '768':
        _dragdrop.resizeScreen('768');
        break;
      case '960':
        _dragdrop.resizeScreen('960');
        break;
      case '1280':
        _dragdrop.resizeScreen('1280');
        break;
      case 'load':
        _load();
        break;
      case 'save':
        _save();
        break;
    }

  }

}
