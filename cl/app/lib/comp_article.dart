import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'dart:async';
import 'deleteArticle/dialog.dart';

import 'comp_articles.dart';
import 'config.dart' as config;
import 'package:k07me.prop/prop.dart' as prop;

//
@Component(
    selector: "art-component",
    directives: const[DeleteArticleDialog,ROUTER_DIRECTIVES],
    template: """
    <div>
    <div *ngIf='url!=""'>
    <a href='{{url}}' style='font-size:8px;' target="_blank">
       <div #imagecont></div>
    </a> </div>
    <div *ngIf='url==""'>
    <div #imagecont></div>
    </div>
    <div style='font-size:18px;font-weight:bold;'>{{artInfo.title}}</div>
    <div style='font-size:14px;'#userinfocont></div>
    <div *ngIf='url!=""'>
      <a href='{{url}}' style='font-size:8px;' target="_blank">goto this site</a>
    </div>
    <hr>
    <div style='font-size:14px;'>
    User :
    <a [routerLink]="['User',{name:artInfo.userName}]">{{artInfo.userName}}</a>
    </div>
    <button *ngFor='let t of artInfo.tags' (click)='onClickTag(t)'>{{t}}</button>
    <div *ngIf='info.isUpdatable(artInfo.userName)'>
      <button (click)='onEdit()'>Edit</button>
      <button (click)='onDelete(myDialoga)'>Delete</button>
    </div>
    <deletearticle-dialog [param]='param' #myDialoga>
    </deletearticle-dialog>
    </div>
  """,
)
class ArticleComponent implements OnInit, DynamicItem {
  final RouteParams _routeParams;
  final Router _router;
  String iconUrl = "";

  @Input()
  ArticlesComponent parent = null;


  @Input()
  int width = 200;
  int height = 300;

  final ElementRef element;
  html.Element _imageContElm = null;
  @ViewChild('imagecont')
  set image(ElementRef elementRef) {
    if(elementRef == null || elementRef.nativeElement == null) {
      return;
    }
    _imageContElm  = elementRef.nativeElement;

  }

  @Input()
  String userName;

  @Input()
  ArticleComponentInfo info = new ArticleComponentInfo();


  ArtInfoProp _artInfo = null;
  String url = "";

  @Input()
  void set artInfo(ArtInfoProp v) {
    _artInfo = v;
    NewArtProp newArtProp = null;
    var vv = new prop.MiniProp.fromString(v.info);
    url = vv.getString("url", "");
  }

  ArtInfoProp get artInfo => _artInfo;




  html.Element _mainElement;

  Map<String,Object> params= {};
  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
  }

  ArticleComponent(this.element,this._router, this._routeParams){
    //params["tag"] = _routeParams.get("tag");
    //params["user"] = _routeParams.get("user");
    var elm = element.nativeElement;
    print("${elm}");
    (elm as html.Element).style.width = "${width}px";
    (elm as html.Element).style.boxShadow = "0px 0px 1px 0px rgba(0, 0, 0, 0.2)";
    (elm as html.Element).style.borderRadius = "10px";
    (elm as html.Element).style.display = 'inline-block';
    (elm as html.Element).style.position = "relative";
    (elm as html.Element).style.visibility = "hidden";
    (elm as html.Element).style.transition = "all 500ms";
    (elm as html.Element).style.opacity = "0";
  }


  ngOnInit() {
    if (artInfo == null){
      artInfo = new ArtInfoProp(new MiniProp());
    }
    var elm = element.nativeElement;
    (elm as html.Element).style.width = "${width}px";
    updateInfo();
  }

  updateInfo() async {
    if(info.artNBox != null && artInfo != null) {
      try {
        _mainElement.style.width ="${width}px";
        if(artInfo.iconUrl == null || artInfo.iconUrl == ""){
          iconUrl = "";
          if(_imageContElm != null) {
            _imageContElm.children.clear();
          }
        } else {
          html.ImageElement imgElm = new html.ImageElement(width:width);
          Completer c = new Completer();
          imgElm.onLoad.listen((e){
            c.complete("");
          });
          imgElm.onError.listen((e){
            c.complete("");
          });
          iconUrl = await info.artNBox.createBlobUrlFromKey(artInfo.iconUrl);
          imgElm.style.borderRadius = "10px";
          imgElm.src = iconUrl;
          print("-->A 1");

          await c.future;
          print("-->A 2 ${width}");
          _imageContElm.style.width = "${width}px";
          _imageContElm.children.clear();
          _imageContElm.children.add(imgElm);
        }
      } catch(e) {
        print("--e-- ${e}");
      }
    }
    updateContent(artInfo.cont);

  }

  updateContent(String cont) {
    _mainElement.children.clear();
    _mainElement.children.add(//
        new html.Element.html("""<div> ${cont.replaceAll("\n","<br>")}</div>""",//
            treeSanitizer: html.NodeTreeSanitizer.trusted));
    this.height =(element.nativeElement as html.Element).clientHeight;
    print("==height  :  ${height}");
    if(parent != null) {
      parent.append(this);
    }
    var elm = element.nativeElement;
    (elm as html.Element).style.visibility = "visible";
    (elm as html.Element).style.opacity = "1";
//    opacity: 0;
  }

  onEdit(){
    _router.navigate(["Post",{"id":artInfo.articleId}]);
  }

  DeleteArticleDialogParam param = new DeleteArticleDialogParam();
  onDelete(DeleteArticleDialog d) {
    param.onDeleteFunc = (DeleteArticleDialog dd) async {
      await info.artNBox.deleteArticleWithToken(info.accessToken, _artInfo.articleId);
      info.onRemove(artInfo);
    };
    param.title = "delete";
    param.message = "delete article";
    d.open();
  }

  onClickTag(t){
    if(info != null) {
      info.onClickTag(t);
    }
  }
}

class ArticleComponentInfo {
  ArticleComponentInfo();
  String get userName => config.AppConfig.inst.cookie.userName;

  ArtNBox get artNBox => config.AppConfig.inst.appNBox.artNBox;

  String get accessToken => config.AppConfig.inst.cookie.accessToken;

  bool isUpdatable(String userName) => (config.AppConfig.inst.cookie.userName == userName|| config.AppConfig.inst.cookie.isMaster != 0);

  onRemove(ArtInfoProp art) {
  }

  onClickTag(String t) {

  }
}