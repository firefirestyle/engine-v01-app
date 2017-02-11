import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';
import 'dynablock.dart' as dyna;
import 'dart:html' as html;
import 'dart:async';
import 'package:angular2_components/angular2_components.dart';

@Component(
    selector: "arts-component",
    directives: const [ArticleComponent,materialDirectives],
    template: """
    <div #container style='width:100%;'>
    <div *ngFor='let artInfo of artInfos' style='position:relative;'>
        <art-component [parent]='own' [info]='info' [artInfo]='artInfo'  [width]='itemWidth'></art-component>
    </div>
    </div>
    <div *ngIf='isLoading==false' (click)='onNext()'>
    <div align=center class='more'>MORE</div>
    </div>
    <div *ngIf='isLoading==true' align=center>
    <material-spinner></material-spinner>
    </div>
  """,
    styles: const ["""
    .more {
      border-radius: 10px;
      box-shadow: 0px 0px 1px 0px rgba(0, 0, 0, 0.2);
      padding: 10px;
      background-color: #ffffff;
      color: black;
      margin: 0 auto;
      text-align: center;
      vertical-align: center;
     }
    .more:hover {
      background-color: #555;
      color: white;
     }
    """]
)
class ArticlesComponent implements OnInit {
  final ElementRef _artsComponentElementRef;
  final Router _router;

  ArticleComponentInfo info;
  ArticlesComponent own = null;
  bool isLoading = false;

  int _itemWidth = 0;
  int get itemWidth {
    if(_itemWidth == 0) {
     _itemWidth = (dynaCore.rootWidth - 20) ~/ 2;
    }
    return _itemWidth;
  }

  ArticlesComponent(this._artsComponentElementRef, this._router) {
    html.Element v = (_artsComponentElementRef.nativeElement as html.Element);
    v.style.display = "block";
    v.style.position = "relative";
    Timer timer = new Timer(new Duration(seconds: 1),(){});
    html.window.onResize.listen((e) {
      timer.cancel();
      timer = new Timer(new Duration(milliseconds: 500),(){
        print(">>>>> onResize  ${(_artsComponentElementRef.nativeElement as html.Element).clientWidth}");
        onResize();
      });
    });
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
    try {
      isLoading = true;
      ArtNBox artNBox = config.AppConfig.inst.appNBox.artNBox;
      ArtKeyListProp list = await artNBox.findArticle(cursor, props: {"s": "p"}, tags: getTags(), userName: getUserName());
      cursor = list.cursorNext;
      if (dynaCore == null) {
        dynaCore = new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
      }


      List<Future> fs = [];
      var ks = new List.from(list.keys);
      while (0 < ks.length) {
        while (0 < ks.length && fs.length < 5) {
          String key = ks.removeAt(0);
          fs.add(artNBox.getArtFromStringId(key));
        }

        for (var artInfofs in fs) {
          artInfos.add(await artInfofs);
        }
        fs.clear();
      }
    } finally {
      isLoading = false;
    }
  }

  //
  //
  List<DynamicItem> items = [];
  onResize() {
    dynaCore = new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);

    for(var ap in items) {
      var elm = ap.element.nativeElement;
      dyna.FreeSpaceInfo info = dynaCore.addBlock(ap.width + 10, ap.height + 10);
      elm.style.position = "absolute";
      elm.style.left = "${(info.xs + 5)}px";
      elm.style.top = "${info.y}px";
      print("${(info.xs + 5)}  ${info.y} :: ${ap.width } ${ap.height}");
    }

    (_contElm).style.height = "${dynaCore.rootHeight + 20}px";
  }

  dyna.DynaBlockCore dynaCore = null;

  append(DynamicItem ap) {
    if (ap.element == null) {
      return;
    }
    if (dynaCore == null) {
      dynaCore = new dyna.DynaBlockCore(rootWidth: (_artsComponentElementRef.nativeElement as html.Element).clientWidth);
    }
    var elm = ap.element.nativeElement;
    dyna.FreeSpaceInfo info = dynaCore.addBlock(ap.width + 10, ap.height + 10);
    elm.style.position = "absolute";
    elm.style.left = "${(info.xs + 5)}px";
    elm.style.top = "${info.y}px";
    // print(">>lt: ${elm.style.left}px ${elm.style.top}px");
    (_contElm).style.display = "block";
    (_contElm).style.height = "${dynaCore.rootHeight + 20}px";
    items.add(ap);
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