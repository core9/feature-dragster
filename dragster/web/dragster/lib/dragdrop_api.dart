library dragdrop;

import 'dart:html';
import 'package:html5lib/parser.dart' show parse;
import "package:dice/dice.dart";

import 'dart:js';
import "package:json_object/json_object.dart";

import 'highlight_api.dart';
import 'menu_api.dart';
import 'grid_api.dart';



import 'nedb.dart';
import 'utils.dart';

part 'src/dragdrop_impl.dart';

abstract class DragDrop {
  void start();
  void resizeScreen(String strSize);
  void initDragAndDrop(HighLight _highLight);
  void addEventsToColumn(Element col , HighLight _highLight);

}

