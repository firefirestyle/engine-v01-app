// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_post_art.dart';
import 'package:k07me.netbox/netbox.dart';

@Component(
    selector: "my-users",
    directives: const [PostArticleComponent],
    template:  """
    <div class="mybody">
    <post-article-component
    [artNBox]='rootConfig.appNBox.artNBox'
    [accessToken]='rootConfig.cookie.accessToken'
    [userName]='rootConfig.cookie.userName'
    [artInfo]='artInfo'></post-article-component>
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
class PostArticlePage implements OnInit {
  final RouteParams _routeParams;
 ArtInfoProp artInfo = new ArtInfoProp.empty();
  PostArticlePage(this._routeParams){
    artInfo = new ArtInfoProp.empty()
      ..articleId = _routeParams.get("id")
      ..userName = rootConfig.cookie.userName;
  }
  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {

  }
}