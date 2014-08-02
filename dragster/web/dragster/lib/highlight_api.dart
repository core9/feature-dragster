library highlight;

import 'dart:html';
import 'dart:convert';

part 'src/highlight_impl.dart';

abstract class HighLight {
  void start();
  void initHighlight();
  void activateHighLight(Element e);
  void resetOnMouseOver(Element element);
}
