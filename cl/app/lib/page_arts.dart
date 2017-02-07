import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_article.dart';
import 'comp_articles.dart';


@Component(
    selector: "my-arts",
    directives: const [ArticleComponent, ArticlesComponent],
    template:  """<arts-component [params]='params'></arts-component>""",
)
class ArtsPage implements OnInit {
  final RouteParams _routeParams;
  Map<String,Object> params = {};

  ArtsPage(this._routeParams){
    params["tag"] = this._routeParams.get("tag");
    params["user"] = this._routeParams.get("user");
  }
  ngOnInit() {
    updateConfig();

  }

  updateConfig(){
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
