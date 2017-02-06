import 'package:k07me.httprequest/request.dart';
import 'package:k07me.httprequest/request_io.dart';
import 'package:k07me.netbox/netbox.dart';
import 'package:k07me.netbox/netbox_io.dart';

import 'dart:io';
import 'dart:async';

main(List<String> args) async {
  String backAddr = args[0];
  OAuthLoginHelper helper = new OAuthLoginHelper(OAuthLoginHelperType.twitter,backAddr);
  print("start");
  MeNBoxLoginCB cbinfo = await helper.login();
  print("a : ${cbinfo.permission}");
  print("b : ${cbinfo.token}");
  print("c : ${cbinfo.userName}");
  print("d : ${cbinfo.error}");
  print("end");

}
