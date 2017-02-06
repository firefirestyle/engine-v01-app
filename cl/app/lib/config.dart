import 'package:cookie/cookie.dart' as cookie;
import 'cookie.dart';
import 'package:k07me.netbox/netbox.dart';
import 'package:k07me.httprequest/request_html.dart';

class AppConfig {
  static AppConfig inst = new AppConfig();
  MyCookie _cookie= new MyCookie();
  MyCookie get cookie=> _cookie;


  String get clientAddr => "http://localhost:8085";

  String get baseAddr => "http://localhost:8080";

  String makeUrl(path) => baseAddr + path;

  AppNetBox appNBox;

  AppConfig(){
    appNBox = new AppNetBox(new UserNBox(new Html5NetBuilder(), baseAddr),//
        new MeNBox(new Html5NetBuilder(), baseAddr),//
        new ArtNBox(new Html5NetBuilder(), baseAddr));
  }

  String get twitterLoginUrl =>
      makeUrl("""/api/v1/twitter/tokenurl/redirect?cb=${Uri.encodeFull(
          clientAddr + "/")}""");
}

class AppNetBox {
  UserNBox userNBox;
  MeNBox meNBox;
  ArtNBox artNBox;
  AppNetBox(this.userNBox, this.meNBox, this.artNBox){
  }
}