// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';
import 'comp_articles.dart';


@Component(
    selector: "my-arts",
    directives: const [ArticleComponent, ArticlesComponent],
    template:  """
    <div class="mybody">
    <arts-component
     [params]='params'></arts-component>
    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      min-height: 400px;
    }
    """,
    ]
)
class ArtsPage implements OnInit {
  final RouteParams _routeParams;
  config.AppConfig rootConfig = config.AppConfig.inst;
  Map<String,Object> params = {};

  ArtsPage(this._routeParams){
    params["tag"] = this._routeParams.get("tag");
    params["user"] = this._routeParams.get("user");
  }
  ngOnInit() {
    updateConfig();

  }

  updateConfig(){
    print(_routeParams.params.toString());
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
