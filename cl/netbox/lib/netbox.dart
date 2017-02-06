library firestyle.cl.netbox;

import 'dart:async';

import 'package:k07me.httprequest/request.dart' as req;
//import 'package:firefirestyle.httprequest/request_html.dart' as req;
import 'package:k07me.prop/prop.dart' as pro;
//import 'package:firefirestyle.location/location.dart' as loc;
//import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
//
//
part 'src/usernbox.dart';
part 'src/filenbox.dart';
part 'src/menbox.dart';
part 'src/artnbox.dart';
//
//

class ErrorProp {
  pro.MiniProp prop;
  ErrorProp(this.prop) {}
  //"errorCode"
  //"errorMessage"
  int get errorCode => prop.getNum("errorCode", 0);
  String get errorMessage => prop.getString("errorMessage", "");
}
