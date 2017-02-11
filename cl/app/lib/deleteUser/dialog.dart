import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'dart:async';
import 'package:k07me.netbox/netbox.dart';
import 'package:k07me.prop/prop.dart';
import '../config.dart' as config;


@Component(
  selector: 'deleteuser-dialog',
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
    <input [(ngModel)]='inputValue'>
    <material-spinner *ngIf='isloading'></material-spinner>

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
class DeleteUserDialog implements OnInit {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  @Input()
  DeleteUserDialogParam param;

  String inputValue = "---";
  String errorMessage = "";
  String get content => param.content;
  //
  bool isloading = false;


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
      errorMessage = await param.onDeleteFunc(this);
      wrappingModal.close();
    } catch(e) {
      errorMessage = "${e}";
    } finally {
      isloading = false;
    }
  }
}

typedef Future<String> OnDeleteFunc(DeleteUserDialog d);

class DeleteUserDialogParam {
  String title;
  String message;
  String ok;
  String cancel;
  //
  String content;

  //
  OnDeleteFunc onDeleteFunc = (DeleteUserDialog d) async {
    MeNBox meNBox = config.AppConfig.inst.appNBox.meNBox;
    if(d.inputValue != config.AppConfig.inst.cookie.userName) {
      throw new Exception("input username is wrong ::${d.inputValue}::");
    }
    await meNBox.updateUserInfo(config.AppConfig.inst.cookie.accessToken, config.AppConfig.inst.cookie.userName,status: "private");
  };

  DeleteUserDialogParam({this.title:"Delete User",this.message:"""Your Article could not delete. Are You OK. if OK than, input user name and  push delete button""",this.ok:"Delete",this.cancel:"Cancel",
    onDeleteFunc: null}){
  }

  /**
   * if failed to do onFind func, then return error message.
   */
  Future<String> onDelete(DeleteUserDialog d) async {
    if (onDeleteFunc == null) {
      return "";
    } else {
      return onDeleteFunc(d);
    }
  }
}