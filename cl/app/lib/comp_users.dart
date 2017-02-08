import 'package:angular2/core.dart';
import 'comp_user.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:async';
import 'comp_user.dart';
import 'config.dart' as config;

@Component(
  selector: "user-components",
  directives: const [UserComponent],
  template: """
  <div>
  <div *ngFor='let ui of userInfos'><user-component  [userInfo]='ui'></user-component></div>
  </div>
  <!--> <-->
  <div style='width:100%;height:20px;box-shadow:2px 2px 1px grey;' (click)='onNext()'>
    <div align='center'>MORE</div>
  </div>
  """
)
class UsersComponent implements OnInit {
  List<String> _userNames = [];

  @Input()
  List<UserInfoProp> userInfos = [];

  @Input()
  String cursor = "";

  UsersComponent(){
  }

  ngOnInit() {
    _init();
    for(UserInfoProp user in userInfos) {
      _userNames.add(user.userName);
    }
  }

  _init() async {
    try {
      UserKeyListProp userKeys = await config.AppConfig.inst.appNBox.userNBox.findUser(cursor);
      cursor = userKeys.cursorNext;
      var ks = new List.from(userKeys.keys);
      List<Future> fs = [];
      while(0<ks.length) {
        while(fs.length < 5 && 0<ks.length){
          var key = ks.removeAt(0);
          fs.add(config.AppConfig.inst.appNBox.userNBox.getUserInfoFromKey(key));
        }

        for (var infoPropFs in fs) {
          UserInfoProp infoProp = await infoPropFs;
          if (!_userNames.contains(infoProp.userName)) {
            userInfos.add(infoProp);
          }
        }
        fs.clear();
      }
    } catch(e){
    }
  }
  onNext(){

  }
}

