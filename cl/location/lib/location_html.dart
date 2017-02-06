library firefirestyle.location.html;
import 'dart:html' as html;
import 'package:firefirestyle.location/location.dart';

class HtmlLocation extends Location{

  HtmlLocation(): super.fromHref(html.window.location.href){
  }
}
