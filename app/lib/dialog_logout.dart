import 'package:angular2/core.dart';
import 'config.dart' as config;
import 'package:angular2_components/angular2_components.dart';

@Component(
  selector: 'my-logout-dialog',
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <h3 header>
        Logout?
    </h3>
    <p>
    ...
    </p>
    <div footer>
      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)">
        Cancel
      </material-button>
      <material-button autoFocus clear-size (click)="onLogout(wrappingModal)">
        Logout
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class LogoutDialog {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }
  onLogout(ModalComponent comp) {
    config.AppConfig.inst.cookie.setIsMaster("");
    config.AppConfig.inst.cookie.accessToken = "";
    config.AppConfig.inst.cookie.userName = "";
    wrappingModal.close();
  }
}
