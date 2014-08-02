library grid;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;

abstract class Grid {
  void start();
}

class GridImpl extends Grid {
  
  void start(){
    var dataSource = '/dragster/grid/index.html';
    var request = HttpRequest.getString(dataSource).then(_onDataLoaded);
    
  }
  
  void _onDataLoaded(String responseText) {

    var body = parse(responseText).querySelector('html');
    print(body);

  }
  
}