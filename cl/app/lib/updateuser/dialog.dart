import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'dart:async';
import 'package:k07me.netbox/netbox.dart';
import 'package:k07me.prop/prop.dart';


@Component(
  selector: 'updateuser-dialog',
  styles: const [
    """
    .updateuser-dialog-title {
    }
    .updateuser-dialog-message {
    }
    .updateuser-dialog-errormessage {
    }
    .updateuser-dialog-cancelbutton{
    }
    .updateuser-dialog-okbutton{
    }
    """,
  ],
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <div *ngIf='errorMessage!=""' class='updateuser-dialog-errormessage'>{{errorMessage}}</div>
    <h3 class='updateuser-dialog-title' header>{{param.title}}</h3>
    <p class='updateuser-dialog-message'>{{param.message}}</p>
    <material-spinner *ngIf='isloading'></material-spinner>
    displayName: <br>　<input [(ngModel)]='param.displayName'><br>
    content: <br>　<textarea [(ngModel)]='param.content' style='width:90%;height:50px;'></textarea><br>
    <div footer>
      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)" class='updateuser-dialog-cancelbutton'>
        {{param.cancel}}
      </material-button>
      <material-button autoFocus clear-size (click)="onUpdate(wrappingModal)" class='updateuser-dialog-okbutton'>
        {{param.ok}}
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class UpdateUserDialog implements OnInit {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  @Input()
  UpdateUserDialogParam param;

  bool isloading = false;
  String errorMessage = "";

  String get displayName => param.displayName;
  String get content => param.content;

  ngOnInit(){
  }

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }

  onUpdate(ModalComponent comp) async {
    isloading = true;
    try {
      var ret = await param.onUpdate(this);
      if (ret != "" && ret != null) {
        errorMessage = ret;
      } else {
        errorMessage = "";
        wrappingModal.close();
      }
    } catch (e) {
      errorMessage = "failed to (${e})";
    } finally {
      isloading = false;
    }
  }

}

typedef Future<String> OnUpdateFunc(UpdateUserDialog d);

class UpdateUserDialogParam {
  String title;
  String message;
  String ok;
  String cancel;
  //
  String displayName;
  String content;

  //
  OnUpdateFunc onUpdateFunc;
  UserInfoProp _userInfo = new UserInfoProp(new MiniProp());
  UserInfoProp get userInfo => _userInfo;
  void set userInfo(UserInfoProp v){
    _userInfo = v;
    displayName = _userInfo.displayName;
    content = _userInfo.content;
  }

  UpdateUserDialogParam({this.title:"UserInfo",this.message:"..",this.ok:"Update",this.cancel:"Cancel",
  onUpdateFunc: null}){
  }

  /**
   * if failed to do onFind func, then return error message.
   */
  Future<String> onUpdate(UpdateUserDialog d) async {
    if (onUpdateFunc == null) {
      return "";
    } else {
      return onUpdateFunc(d);
    }
  }
}