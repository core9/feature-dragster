library dragdrop;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;

import 'dart:js';
import "package:json_object/json_object.dart";
import 'dart:convert';

import 'menu.dart';
import 'nedb.dart';
import 'grid.dart';
import 'utils.dart';

part 'src/dragdrop_utilities.dart';

abstract class DragDrop {
  void start();
  void resizeScreen(String strSize);
  void initDragAndDrop();
  void addEventsToColumn(Element col);
  void initHighlight();
  void activateHighLight(Element e);
}

