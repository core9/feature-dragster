library menu;

import 'dart:html';
import 'dart:convert';

import 'dragdrop.dart';

abstract class Menu {
  void start();
}

class MenuImpl extends Menu {
  
  Element _showMenuElement = document.querySelector('#show-menu');
  Element _pageSelector = document.querySelector('#page-selector');
  Element _menuSecondary = document.querySelector('#navigation-secondary');
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
  
  DragDrop _dragdrop;
  void start(){
    
    _dragdrop = new DragDropImpl();
     
    
    
    _showMenuElement.onClick.listen(_showMenu);
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

    _fillMenuInputItems(_menuHostnameJsonDatalist, "/dragster/data/hostnames.json");
    _fillMenuInputItems(_menuPageJsonDatalist, "/dragster/data/pages.json");
    _fillMenuInputItems(_menuVersionJsonDatalist, "/dragster/data/versions.json");
    _fillMenuInputItems(_menuStatusJsonDatalist, "/dragster/data/status.json");
    _fillMenuInputItems(_menuDisplayJsonDatalist, "/dragster/data/displays.json");
    _fillMenuInputItems(_menuUseragentJsonDatalist, "/dragster/data/useragents.json");
    _fillMenuInputItems(_menuPeriodJsonDatalist, "/dragster/data/periods.json");
    _fillMenuInputItems(_menuPercentageJsonDatalist, "/dragster/data/percentages.json");

    _redrawTop('#columns', '#menu');
    
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

  
  
  
}