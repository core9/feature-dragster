library nedb;

import 'dart:js';



class Nedb {
  
  
  
  Nedb() {
    }
  
  JsObject getDb(){
    var  nedb =  new JsObject(context['Nedb']);
    return nedb;
  }
  
}