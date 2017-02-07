import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'config.dart' as config;
import 'package:k07me.prop/prop.dart';

import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';
import 'comp_user.dart';
import 'comp_post_art.dart';
import 'comp_articles.dart';

//
@Component(
    selector: "my-user",
    directives: const[UserComponent, PostArticleComponent, ArticlesComponent],
    template: """
    <div class="mybody">
    <user-component  [userInfo]='userInfo'></user-component>
    <br>

    <arts-component
     [params]='params'></arts-component>
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
class UserPage implements OnInit {
  final RouteParams _routeParams;

  UserInfoProp userInfo = new UserInfoProp(new MiniProp());

  InputImageDialogParam inputDialogParam = new InputImageDialogParam();
  UpdateUserDialogParam updateDialogParam = new UpdateUserDialogParam();

  UserPage(this._routeParams);

  Map<String, Object> get params => {"user": _routeParams.get("name")};

  ngOnInit() {
    _init();
  }

  _init() async {
    UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
    try {
      userInfo = await userNBox.getUserInfo(params["user"]);
    } catch (e) {

    }
  }
}
