library dbimpl;

import 'dart:js';
import "package:json_object/json_object.dart";

import '../db_api.dart';
import '../nedb.dart';

class DBImpl implements DB {
  
  void setupDb() {
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
  
  void _calb(err, count) {
    print("Number of items found : " + count.toString());
  }
  
}