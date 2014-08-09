library utils;

import 'dart:html';


class NullNodeValidator implements NodeValidator {
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }
  bool allowsElement(Element element) {
    return true;
  }
}

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}

class Utils {
  
  Element getFirstParentWithClass(Element element, String className) {
    if (element == null) return null;
    Element parent = element.parent;
    if (parent != null) {
      if (parent.classes.contains(className)) return parent;
    }
    return getFirstParentWithClass(parent, className);
  }
  
}
