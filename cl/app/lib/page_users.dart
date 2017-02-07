
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';

@Component(
    selector: "my-users",
    directives: const [UsersComponent],
    template:  """
    <div class="mybody">
    <h1>Users</h1>
    <user-components></user-components>
    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      min-height: 600px;
    }
    """,
    ]
)
class UsersPage implements OnInit {
  final RouteParams _routeParams;
  UsersPage(this._routeParams);
  ngOnInit() {
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
