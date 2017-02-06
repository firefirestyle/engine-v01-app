import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;

//
//import 'package:cl/hello_dialog/hello_dialog.dart';
//
import 'dialog_logout.dart';

//
@Component(
    selector: "mybody",
    directives: const [LogoutDialog],
    template: """
    <div class="mybody">
    <h1>Login</h1>
    <div *ngIf='rootConfig.cookie.accessToken == ""'>
    <a href='{{twitterLoginUrl}}'>use Twitter</a>
    </div>
    <div *ngIf='rootConfig.cookie.accessToken != ""'>
    <button (click)='onLogout(myDialoga)'>Logout</button>
    </div>

    <my-logout-dialog #myDialoga
             [name]="'as'">
    </my-logout-dialog>

    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      height: 600px;
    }
    """,
    ]
)
class MeComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;

  MeComponent(this._routeParams);

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
  }

  onLogout(LogoutDialog _dialog) async {
    _dialog.open();
  }
}
