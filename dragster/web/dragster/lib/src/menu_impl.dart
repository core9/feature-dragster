library menu_impl;

import 'package:crypto/crypto.dart';
import 'package:html5lib/parser.dart' show parse;
import 'package:lawndart/lawndart.dart';
import "package:dice/dice.dart";
import 'dart:convert';
import 'dart:html';

import '../menu_api.dart';
import '../highlight_api.dart';
import '../dragdrop_api.dart';
import '../stage_api.dart';
import '../utils.dart';




class MenuImpl extends Menu {


  
  String stage = '#columns';
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

  List<Element> _allTemplates;

  List<Element> _menuInputItems = new List(11);
  List<String> _excludeFromHash = new List(1);




  var _db = new Store('dbName', 'storeName');
  
  @inject
  HighLight _highLight;
  
  Stage _stage;
  DragDrop _dragdrop;
  
  void setStage(Stage stage){
    _stage = stage;
  }
  
  void setDragDrop(DragDrop dragdrop){
    _dragdrop = dragdrop;  
  }
  
  void start() {
    
    _stage.setMenu(this);
    
    _load(false);
    _redrawTop('#columns', '#menu');
    _excludeFromHash[0] = 'menu-action';
    _dragdrop.setStage(_stage);
    _showMenuElement.onClick.listen(_showMenu);
    _putMenuItemsInListAndAddClickEvent();
    _ulMenuAddClickEvents();
    _menuAddOptions();

  }

  void menuAddAllElementTemplates() {
    UListElement ul = document.querySelector('#all-templates');
    _allTemplates = document.querySelectorAll('template');
    for (Element item in _allTemplates) {
      
      if(item.classes.contains('element')){
        print(item.id);
        List<String> classes = [];
        classes.add('menu');
        classes.add('template-element');
        LIElement li = new LIElement();
        AnchorElement link = new AnchorElement();
        link.classes.addAll(classes);
        link.setAttribute('href', '#' + item.id);
        link.text = item.id;
        li.append(link);
        ul.append(li);
        
      }
      
    }
  }

  void _load(bool state) {
    String hash = _getState(state);
    _db.open().then((_) => _db.getByKey(hash)).then((value) {
      if (value != null && value != "") {
        var innerHtml = parse(value).querySelector(stage).innerHtml;
        _stage.getStage().children.clear();
        _stage.getStage().setInnerHtml(innerHtml, treeSanitizer: new NullTreeSanitizer());
        _dragdrop.initDragAndDrop(_highLight);
      } else {
        _saveLocal();
        _load(false);
      }
    });
  }

  void _clear() {
    String hash = _getState(true);
    _db.open().then((_) => _db.save("", hash));
  }

  void _save() {
    _saveLocal();
  }

  void _saveLocal() {
    String hash = _getState(true);
    String html = _stage.getStage().outerHtml.toString();

    _db.open().then((_) => _db.save(html, hash));
  }

  String _getState(bool state) {
    String hash = "";
    if (state) {

      var re = new RegExp('/\W/g');
      for (InputElement item in _menuInputItems) {
        if (!_excludeFromHash.contains(item.id)) {
          hash += item.value.trim().toLowerCase().replaceAll(re, '').replaceAll(' ', '');
        }
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
  
  void addWidgetToMenu(UListElement ul, String widget) {
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
    document.querySelector(target).style.setProperty('top', (document.querySelector(source).borderEdge.height + 30).toString() + 'px');
  }

  void _onInputMenuChange(Event event) {
    InputElement inputBox = event.target;
    switch (inputBox.id) {
      case 'menu-display':
        _stage.resizeStage(inputBox.value);
        break;
      case 'menu-version':
        break;
    }
    _load(true);
  }



  void _attachDataList(String responseText, Element optionList) {

    List parsedList = JSON.decode(responseText);
    for (var value in parsedList) {
      Element option = document.createElement('option');
      option.setAttribute('value', value);
      optionList.append(option);
    }
  }

  UListElement _getParentElement(Element menuTarget) {

    Element parent = menuTarget.parent;

    if (parent != null && parent.tagName != 'UL') {
      parent = _getParentElement(parent);
    }

    return parent;
  }

  void _onClickMenuItem(MouseEvent event) {
    Element menuTarget = event.target;

    if (menuTarget.tagName != 'INPUT') {
      UListElement parent = _getParentElement(menuTarget);
      if(parent == null) return;

      print(parent.id);
      switch (parent.id) {
        case 'all-widgets':
          _addWidgetToStage(menuTarget);
          break;
        case 'all-elements':
          //_addElementToStage(menuTarget);
          break;
        default:
          _nonWidgetAndElements(menuTarget);
          break;
      }
    }
  }

  void _addWidgetToStage(Element menuTarget) {
    print(menuTarget.text);
    Element template = document.querySelector('#' + menuTarget.text);
    Element widgetPlaceHolder = document.querySelector('#widget-placeholder');
    String innerHtml = template.innerHtml;
    DivElement newDiv = new DivElement();
    List<Element> listDivs = document.querySelectorAll('#columns .column');
    newDiv.id = 'elem' + listDivs.length.toString();
    newDiv.classes.add('column');
    newDiv.setAttribute('draggable', 'true');
    newDiv.setInnerHtml(innerHtml, treeSanitizer: new NullTreeSanitizer());
    document.querySelector('#columns').append(newDiv);
    _save();
    _dragdrop.addEventsToColumn(newDiv, _highLight);
  }

  void _addElementToStage(Element menuTarget) {

  }

  void _nonWidgetAndElements(Element menuTarget) {
    switch (menuTarget.innerHtml.trim().toLowerCase()) {
      case '320':
        _stage.resizeStage('320');
        break;
      case '640':
        _stage.resizeStage('640');
        break;
      case '768':
        _stage.resizeStage('768');
        break;
      case '960':
        _stage.resizeStage('960');
        break;
      case '1280':
        _stage.resizeStage('1280');
        break;
      case 'load':
        _load(true);
        break;
      case 'clear':
        _clear();
        break;
      case 'save':
        _save();
        break;
    }
  }

}
