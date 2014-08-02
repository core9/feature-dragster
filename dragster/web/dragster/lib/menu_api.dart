library menu;

import 'dart:html';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:html5lib/parser.dart' show parse;
import 'package:lawndart/lawndart.dart';
import 'utils.dart';
import "package:dice/dice.dart";
import 'highlight_api.dart';
import 'dragdrop_api.dart';

part 'src/menu_impl.dart';



abstract class Menu {
  void start();
  void menuAddAllElementTemplates();
}
