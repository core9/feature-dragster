import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';



class Clock extends DisplayObjectContainer {
  List _colors = [Color.Black, Color.Blue, Color.Red, Color.Green];
  int _colorIndex = 0;
  TextField _textField;
  
  Clock() {
    _textField = new TextField();
    _textField.defaultTextFormat = new TextFormat("Verdana", 14, Color.Black);
    _textField.width = 200;
    _textField.height = 20;
    _textField.background = true;
    _textField.backgroundColor = Color.Yellow;
    _textField.text = new DateTime.now().toString();
    addChild(_textField);

    this.onEnterFrame.listen(_onEnterFrame);
    this.onMouseClick.listen(_onMouseClick);
  }
  
  _onEnterFrame(EnterFrameEvent e) {
    _textField.text = new DateTime.now().toString();
  }
  
  _onMouseClick(MouseEvent e) {
    _colorIndex = (_colorIndex + 1) % _colors.length;
    _textField.textColor = _colors[_colorIndex];
  }
}


void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  // draw a red circle
  var shape = new Shape();
  shape.graphics.circle(100, 100, 60);
  shape.graphics.fillColor(Color.Red);
  stage.addChild(shape);
  
  stage.addChild(new Clock());
  
  
  
}