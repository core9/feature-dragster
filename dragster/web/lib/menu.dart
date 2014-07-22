library menu;


abstract class Widget {
  // ...Define instance variables and methods...
  num getX(); // Define an abstract method.
}

class WidgetImpl extends Widget {
  num x;      // Declare an instance variable (x), initially null.
  num y;      // Declare y, initially null.
  num z = 0;  // Declare z, initially 0.
  num getX(){
    x = 10;
    return x;
  }
}