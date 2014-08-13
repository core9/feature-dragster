library db;

import 'package:lawndart/lawndart.dart';

abstract class DB {
  
  Store getGridDB();
  Store getPagesDB();
  
}