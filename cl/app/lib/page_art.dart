import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_article.dart';
import 'comp_articles.dart';
import 'package:k07me.netbox/netbox.dart';
import 'package:firefirestyle.location/location_html.dart' as loc;
import 'dart:html' as html;

@Component(
  selector: "my-art",
  directives: const [ArticleComponent],
  template:  """
  <div *ngIf='notFound'>
  <div style='font-size:6px;'>Home</div>
  Not found {{articleId}}
  </div>
  <div *ngIf='artInfo!=null'>
  <art-component [info]='info' [artInfo]='artInfo'  [width]='width'></art-component>
  </div>
  """,
)
class ArtPage implements OnInit {
  final Router _router;
  final RouteParams _routeParams;
  final ElementRef _elementRef;
  Map<String, Object> params = {};

  ArtInfoProp artInfo;
  ArticleComponentInfo info = new ArticleComponentInfo();
  bool notFound = false;
  String articleId = "";

  int get width {
   int w =  (_elementRef.nativeElement as html.Element).clientWidth;
   return w;
  }
  ArtPage(this._router,this._routeParams, this._elementRef) {
    params["tag"] = this._routeParams.get("tag");
    params["user"] = this._routeParams.get("user");
    (_elementRef.nativeElement as html.Element).style.display = "block";
  }

  ngOnInit() async {
    try {
      String path = (new loc.HtmlLocation()).path;
      articleId = path.replaceFirst("/", "");
      ArtNBox artNBox = config.AppConfig.inst.appNBox.artNBox;
      artInfo = await artNBox.getArtFromArticleId(articleId, "");
    } catch(e){
      notFound = true;
    }
  }
}
