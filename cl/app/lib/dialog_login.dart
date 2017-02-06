import 'package:angular2/core.dart';
import 'config.dart' as config;
import 'package:angular2_components/angular2_components.dart';

@Component(
  selector: 'my-login-dialog',
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <h3 header>
        Login?
    </h3>
      <a href='{{twitterLoginUrl}}'>use Twitter</a>
      <br style='clear:both;'>
    <div footer>

      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)">
        Cancel
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class LoginDialog implements OnInit{
  String twitterLoginUrl = "";
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
  }

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
