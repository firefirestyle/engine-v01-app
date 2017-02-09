import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';
import 'dynablock.dart' as dyna;
import 'dart:html' as html;
import 'dart:async';

@Component(
    selector: "arts-component",
    directives: const [ArticleComponent],
    template: """
    <div #container>
    <div *ngFor='let artInfo of artInfos' style='position:relative;'>
        <art-component [parent]='own' [info]='info' [artInfo]='artInfo'  [width]='((dynaCore.rootWidth-20)/2)'></art-component>
    </div>
    </div>
    <div style='width:100%;height:20px;box-shadow:2px 2px 1px grey;' (click)='onNext()'>
    <div align='center'>MORE</div>
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
  String cursor = "";

  @Input()
  Map<String, Object> params = {};

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    update();
  }

  html.Element _contElm = null;

  @ViewChild('container')
  set image(ElementRef elementRef) {
    if (elementRef == null || elementRef.nativeElement == null) {
      return;
    }
    _contElm = elementRef.nativeElement;
  }

  onNext() {
    update();
  }

  update() async {
    ArtNBox artNBox = config.AppConfig.inst.appNBox.artNBox;
    ArtKeyListProp list = await artNBox.findArticle(cursor, props: {"s": "p"}, tags: getTags(), userName: getUserName());
    cursor = list.cursorNext;
    if (dynaCore == null) {
      dynaCore = new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
    }


    List<Future> fs = [];
    var ks = new List.from(list.keys);
    while(0 < ks.length) {
      while (0 < ks.length && fs.length < 5) {
        String key = ks.removeAt(0);
        fs.add(artNBox.getArtFromStringId(key));
      }

      for (var artInfofs in fs) {
        artInfos.add(await artInfofs);
      }
      fs.clear();
    }
  }

  //
  //
  dyna.DynaBlockCore dynaCore = null;

  append(DynamicItem ap) {
    if (ap.element == null) {
      return;
    }
    if (dynaCore == null) {
      dynaCore = new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
    }
    var elm = ap.element.nativeElement;
    dyna.FreeSpaceInfo info = dynaCore.addBlock(
        ap.width + 10, ap.height + 10);
    elm.style.position = "absolute";
    elm.style.left = "${(info.xs + 5)}px";
    elm.style.top = "${info.y}px";
    // print(">>lt: ${elm.style.left}px ${elm.style.top}px");
    (_contElm).style.display = "block";
    (_contElm).style.height = "${dynaCore.rootHeight + 20}px";
  }

  //
  //
  //

  List<String> getTags() {
    var v = params["tag"];
    if (v == "" || v == null) {
      return [];
    } else {
      return [v];
    }
  }

  String getUserName() {
    var v = params["user"];
    if (v == "" || v == null) {
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

  MyArticleComponentInfo({this.parent: null}) : super();


      onRemove(ArtInfoProp art) {
    if (parent != null && parent.artInfos.contains(art)) {
      parent.artInfos.remove(art);
    }
  }

  onClickTag(String t) {
    parent._router.navigate(["Arts", {"tag": t}]);
  }
}