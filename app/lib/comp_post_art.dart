import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;
import 'dart:html' as html;
import 'package:k07me.netbox/netbox.dart';
import 'inputimgage/dialog.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart' as prop;
import 'package:angular2_components/angular2_components.dart';
import 'dart:async';
//
@Component(
    selector: "post-article-component",
    directives: const [InputImageDialog,materialDirectives],
    providers: const [materialProviders],
    template: """
    <div class="mybody">
      <h1>Post Article</h1>
      <div>{{message}}</div>
      <material-spinner *ngIf='isloading'></material-spinner>
      <div>{{artInfo.articleId}}</div>
      <div><label>Title</label><br>
      <input [(ngModel)]='artInfo.title' class='title'>
      </div>
      <div><label>Tag</label><br>
      <input [(ngModel)]='tag' (keyup.enter)='onEnterTag()' class='content'><br>
      <button *ngFor='let t of artInfo.tags' (click)='onClickTag(t)'>(x) {{t}}</button>
      </div>
      <div>
      <label>URL</label><br>
      <input [(ngModel)]='url' class='content'>
      </div>
      <div><label>Message</label><br>
      <textarea [(ngModel)]='artInfo.cont' class='content'></textarea>
      </div>


      <button (click)='onUpdateIcon(myDialoga)' *ngIf='!isloading'>add image</button>
      <button #btn (click)='onPost(btn)' *ngIf='!isloading'>Post</button>

      <div *ngFor='let src of imageSrcs'>
        <img src='{{src}}'>
      </div>
    <inputimage-dialog [param]="param" #myDialoga>
    </inputimage-dialog>
    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      height: 600px;
    }
    .title {
      width:80%;
    }
    .content {
      width:80%;
    }
    """,
    ]
)
class PostArticleComponent implements OnInit {
  final RouteParams _routeParams;

  @Input()
  ArtInfoProp artInfo = new ArtInfoProp.empty();

  @Input()
  ArtNBox artNBox = null;

  @Input()
  String accessToken = "";

  bool isloading = false;

  String tag = "";

  String url = "";

  String message = "";

  //
  //
  InputImageDialogParam param = new InputImageDialogParam();
  config.AppConfig rootConfig = config.AppConfig.inst;
  List<String> imageSrcs = [];

  PostArticleComponent(this._routeParams){
  }

  ngOnInit(){
    updateInfo();
  }

  updateInfo() async {
    print("updateInfo ${artInfo.tags}");
    if(artInfo.articleId != null && artInfo.articleId !="new" && artInfo.articleId!="") {
    artInfo = await artNBox.getArtFromArticleId(artInfo.articleId,"");
      if(artInfo.iconUrl != "" && artInfo.iconUrl != null) {
        updateIcon(await artNBox.createBlobUrlFromKey(artInfo.iconUrl));
      }
    }
    prop.MiniProp infoProp = new prop.MiniProp.fromString(artInfo.info);
    url = infoProp.getString("url", "");
  }

  onPost(html.Element v) async {
    try {
      isloading = true;
      message = "loading...";
      NewArtProp newArtProp = null;
      var v = new prop.MiniProp.fromMap({"url": url});
      if (artInfo.articleId == "" || artInfo.articleId == "new" || artInfo.articleId == null) {
        newArtProp = await artNBox.newArt(accessToken, artInfo.userName, title: artInfo.title,
            cont: artInfo.cont,
            //
            props: {"s": "p"},
            tags: artInfo.tags,
            info: v.toJson());
      } else {
        newArtProp = await artNBox.updateArt(accessToken, artInfo.articleId, userName: artInfo.userName,
            title: artInfo.title,
            cont: artInfo.cont,
            //
            props: {"s": "p"},
            tags: artInfo.tags,
            info: v.toJson());
      }
      if (imageSrcs.length > 0 && false == imageSrcs[0].startsWith("http")) {
        var v = conv.BASE64.decode(imageSrcs[0].replaceFirst(new RegExp(".*,"), ''));
        await artNBox.updateFile(accessToken, newArtProp.articleId, "", "icon", v);
      }
      //
      //
      await new Future.delayed(new Duration(seconds: 1));
      message = "complete";
    } finally {
      isloading = false;
    }
  }

  //      var i = conv.BASE64.decode(currentImage.src.replaceFirst(new RegExp(".*,"), ''));
  onUpdateIcon(InputImageDialog dd) async {
    param.onFileFunc = (InputImageDialog dd) async {
      var currentImage = dd.currentImage;
      updateIcon(currentImage.src);

     };
    dd.open();
  }

  onEnterTag(){
    var v = artInfo.tags;
    v.add("${tag}");
    artInfo.tags =v;
    tag = "";
  }

  onClickTag(String vv) {
    var v = artInfo.tags;
    v.remove(vv);
    artInfo.tags =v;
  }

  updateIcon(String src) async {
    imageSrcs.add(src);
  }
}
