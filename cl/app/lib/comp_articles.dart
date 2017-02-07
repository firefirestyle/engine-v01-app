import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';
import 'dynablock.dart' as dyna;
import 'dart:html' as html;
import 'package:k07me.prop/prop.dart';
@Component(
    selector: "arts-component",
    directives: const [ArticleComponent],
    template: """
    <div class="mybody">
    <div *ngFor='let artInfo of artInfos' style='position:relative;'>
        <art-component [parent]='own' [info]='info' [artInfo]='artInfo'  [imageWidth]='((dynaCore.rootWidth-90)/2)'></art-component>
    </div>
    </div>
  """
)
class ArticlesComponent implements OnInit {
  final ElementRef _artsComponentElementRef;
  final Router _router;

  ArticleComponentInfo info;
  ArticlesComponent own = null;

  ArticlesComponent(this._artsComponentElementRef, this._router) {
    (_artsComponentElementRef.nativeElement as html.Element).style.display = "block";
    own = this;
    info = new MyArticleComponentInfo(parent: this);
  }

  @Input()
  Map<String,Object> params= {};

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    update();
  }



  update() async {
    ArtNBox artNBox = config.AppConfig.inst.appNBox.artNBox;
    ArtKeyListProp list = await artNBox.findArticle("", props: {"s": "p"},tags: getTags(),userName: getUserName());
    if(dynaCore == null) {
      dynaCore =  new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
    }

    for (String key in list.keys) {
      ArtInfoProp artInfo = await artNBox.getArtFromStringId(key);
      artInfos.add(artInfo);
    }
  }
  //
  //
  dyna.DynaBlockCore dynaCore = null;
  append(DynamicItem ap) {
    if(ap.element == null) {
      return;
    }
    if(dynaCore == null) {
      dynaCore =  new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
    }
    var elm = ap.element.nativeElement;
    dyna.FreeSpaceInfo info = dynaCore.addBlock(
        ap.width + 10, ap.height + 10);
    elm.style.position = "absolute";
    elm.style.left = "${info.xs}px";
    elm.style.top = "${info.y}px";
    print(">>lt: ${elm.style.left}px ${elm.style.top}px");
    (_artsComponentElementRef.nativeElement as html.Element).style.display = "block";
    (_artsComponentElementRef.nativeElement as html.Element).style.height = "${dynaCore.rootHeight+20}px";
  }

  //
  //
  //

  List<String> getTags() {
    var v = params["tag"];
    if(v == "" || v== null) {
      return [];
    } else {
      return [v];
    }
  }

  String getUserName() {
    var v = params["user"];
    if(v == "" || v== null) {
      return "";
    } else {
      return Uri.decodeComponent(v);
    }
  }
}

abstract class DynamicItem {
  ElementRef get element;
  int get width;
  int get height;
}

class MyArticleComponentInfo extends ArticleComponentInfo {
  final ArticlesComponent parent;

  MyArticleComponentInfo({this.parent: null}) : super() ;

  bool isUpdatable(String userName) => (parent == null ? false : config.AppConfig.inst.cookie.userName == userName);

  onRemove(ArtInfoProp art) {
    if (parent != null && parent.artInfos.contains(art)) {
      parent.artInfos.remove(art);
    }
  }

  onClickTag(String t) {
    parent._router.navigate(["Arts",{"tag":t}]);
  }
}