
import 'dart:html';

import 'lib/bootstrategy_api.dart';
import 'lib/src/bootstrategy_impl.dart';

import 'lib/dragdrop_api.dart';
import 'lib/src/dragdrop_impl.dart';
import 'lib/highlight_api.dart';
import 'lib/src/highlight_impl.dart';
import 'lib/menu_api.dart';
import 'lib/src/menu_impl.dart';
import 'lib/grid_api.dart';
import 'lib/stage_api.dart';
import 'lib/src/stage_impl.dart';
import 'lib/select_api.dart';
import 'lib/src/select_impl.dart';


import 'lib/temp_main.dart';

List<Element> _columnsElements = document.querySelectorAll('#columns');

void main() {

  Registry module = new Registry();
  module.registerToInstance(HighLight, new HighLightImpl());
  module.registerToInstance(Select, new SelectImpl());
  module.registerToInstance(DragDrop, new DragDropImpl());
  module.registerToInstance(Grid, new GridImpl());
  module.registerToInstance(Menu, new MenuImpl());
  module.registerToInstance(Stage, new StageImpl());
  module.registerToInstance(MainStrategy, new MainStrategy());


  
  BootstrapFramework bootstrap = new BootstrapFrameworkImpl();
  bootstrap.addModule(module);
  bootstrap.run();
  
}
