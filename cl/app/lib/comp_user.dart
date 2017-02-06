import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';
import 'dart:async';
import 'config.dart' as config;

//
@Component(
  selector: "user-component",
  directives: const[InputImageDialog, UpdateUserDialog,ROUTER_DIRECTIVES],
  template: """
    <div>
    <img #image1 *ngIf='iconUrl==""' src='/assets/egg.png'>
    <img #image *ngIf='iconUrl!=""' src='{{iconUrl}}'>
    <div style='font-size:24px;'>{{userInfo.displayName}}</div>
    <a [routerLink]="['User',{name:userInfo.userName}]" style='font-size:8px;'>{{userInfo.userName}}</a>

    <div #userinfocont></div>

    <div *ngIf='isUpdatable'>
      <button (click)='onUpdateIcon(myDialoga)'> updateIcon</button>
      <button (click)='onUpdateInfo(myDialogb)'> updateInfo</button>
    </div>

    <inputimage-dialog [param]="paramOfInputImageDialog" #myDialoga>
    </inputimage-dialog>
    <updateuser-dialog [param]="paramOfUpdateDialog" #myDialogb>
    </updateuser-dialog>
    </div>
  """,
)
class UserComponent implements OnInit {
  final RouteParams _routeParams;
  String iconUrl = "";

  @Input()
  int imageWidth = 200;

  @Input()
  int contentWidth = 200;

  UserInfoProp _userInfo = new UserInfoProp(null);
  @Input()
  void set userInfo(UserInfoProp v){
    _userInfo = v;
    updateInfo();
  }
  UserInfoProp get userInfo => _userInfo;


  @ViewChild('image')
  set image(ElementRef elementRef) {
    if (elementRef == null || elementRef.nativeElement == null) {
      return;
    }
    (elementRef.nativeElement as html.ImageElement).style.width = "${imageWidth}px";
  }

  bool get isUpdatable => config.AppConfig.inst.cookie.userName == userInfo.userName;

  MeNBox get meNBox => config.AppConfig.inst.appNBox.meNBox;

  html.Element _userInfoElement;

  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _userInfoElement = elementRef.nativeElement;
    _userInfoElement.style.width = "${contentWidth}px";
  }

  //
  InputImageDialogParam paramOfInputImageDialog = new InputImageDialogParam();
  UpdateUserDialogParam paramOfUpdateDialog = new UpdateUserDialogParam();

  UserComponent(this._routeParams) {
  }


  ngOnInit() {
    updateInfo();
  }

  updateInfo() async {
    if (meNBox != null && userInfo != null) {
      try {
        iconUrl = await meNBox.createBlobUrlFromKey(userInfo.iconUrl);
        _userInfoElement.children.clear();
        _userInfoElement.children.add( //
            new html.Element.html("""<div> ${userInfo.content.replaceAll("\n", "<br>")}</div>""", //
                treeSanitizer: html.NodeTreeSanitizer.trusted));
      } catch (e) {
        print("--e-- ${e}");
      }
    }
  }

  onUpdateIcon(InputImageDialog d) {
    paramOfInputImageDialog = new InputImageDialogParam();
    paramOfInputImageDialog.onFileFunc = (InputImageDialog dd) async {
      if (userInfo == null) {
        return;
      }
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      UploadFileProp prop = await meNBox.updateFile(
          config.AppConfig.inst.cookie.accessToken, "/", "icon.png", //
          i, userName: config.AppConfig.inst.cookie.userName);
      iconUrl = await meNBox.createBlobUrlFromKey(prop.blobKey);
    };
    d.open();
  }

  onUpdateInfo(UpdateUserDialog d) {
    paramOfUpdateDialog = new UpdateUserDialogParam();
    paramOfUpdateDialog.userInfo = userInfo;
    paramOfUpdateDialog.onUpdateFunc = (UpdateUserDialog dd) async {
      userInfo = await meNBox.updateUserInfo(
          config.AppConfig.inst.cookie.accessToken, //
          config.AppConfig.inst.cookie.userName,
          displayName: dd.displayName,
          cont: dd.content
      );
    };
    d.open();
  }
}
