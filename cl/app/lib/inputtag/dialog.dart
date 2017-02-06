import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'dart:async';


@Component(
  selector: 'inputtag-dialog',
  styles: const [],
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <div *ngIf='errorMessage!=""' class='inputimage-dialog-errormessage'>{{errorMessage}}</div>
    <h3 header>{{param.title}}</h3>
    <p>{{param.message}}</p>

    <material-spinner *ngIf='isloading'></material-spinner>
    <input  [(ngModel)]='tag' placeholder="tag">

    <div footer>
      <material-button *ngIf='isloading==false' autoFocus clear-size (click)="onCancel(wrappingModal)">
        {{param.cancel}}
      </material-button>
      <material-button *ngIf='tag!=null||isloading==false' autoFocus clear-size (click)="onTag(wrappingModal)" >
        {{param.ok}}
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class InputImageDialog implements OnInit {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  @Input()
  InputTagDialogParam param = new InputTagDialogParam();

  bool isloading = false;
  String errorMessage = "";
  String tag = "";

  ngOnInit(){
    if(param == null) {
      param = new InputTagDialogParam();
    }
  }

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }

  onTag(ModalComponent comp) async {
    isloading = true;
    try {
      var ret = await param.onTag(this);
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

typedef Future<String> OnTagFunc(InputImageDialog d);

class InputTagDialogParam {
  String title;
  String message;
  String ok;
  String cancel;
  OnTagFunc onTagFunc;

  InputTagDialogParam({this.title:"Input Tag",this.message:"..",this.ok:"OK",this.cancel:"Cancel",
  onFileFunc: null}){
  }

  /**
   * if failed to do onFind func, then return error message.
   */
  Future<String> onTag(InputImageDialog d) async {
    if (onTagFunc == null) {
      return "";
    } else {
      return onTagFunc(d);
    }
  }
}


