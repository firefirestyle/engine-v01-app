// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

//import 'package:cl/app_component.dart';
import 'package:cl/config.dart' as config;
import 'package:cl/comp_me.dart';
import 'dart:async';
import 'dialog_login.dart';
import 'dialog_logout.dart';
import 'page_arts.dart';
import 'page_art.dart';
import 'page_user.dart';
import 'page_users.dart';
import 'page_post_art.dart';
import 'comp_post_art.dart';
import 'dart:html' as html;
import 'package:angular2_components/angular2_components.dart';
import 'dart:js' as js;

@Component(
  selector: "my-app",
  directives: const [LoginDialog, UserPage, UsersPage, LogoutDialog, PostArticlePage, ROUTER_DIRECTIVES, materialDirectives],
  providers: const [ROUTER_PROVIDERS],
  templateUrl:"app_main.html",
  styleUrls:const ["app_main.css"],
)
@RouteConfig(const[
  const Route(
      path: "/users",
      name: "Users",
      component: UsersPage,
      useAsDefault: false),
  const Route(
      path: "/me",
      name: "Me",
      component: MeComponent,
      data: const {"page": "me"},
      useAsDefault: false),
  const Route(
      path: "/user",
      name: "User",
      component: UserPage,
      useAsDefault: false),
  const Route(
      path: "/post",
      name: "Post",
      component: PostArticlePage,
      useAsDefault: false),
  const Route(
      path: "/",
      name: "Arts",
      component: ArtsPage,
      useAsDefault: true),
  const Route(
      path: "/**",
      name: "Art",
      component: ArtPage,
      useAsDefault: false),
]
)
class AppComponent implements OnInit{
  bool useHome = true;
  bool useMe = true;
  bool useUsers = true;
  config.AppConfig rootConfig = config.AppConfig.inst;


  @ViewChild('headera')
  set header(ElementRef elementRef) {
    html.Element el = elementRef.nativeElement;
    html.window.onScroll.listen((e) {
      if (html.window.scrollY > 100) {
        if (false == el.classes.contains("topNavi")) {
          el.classes.add("topNavi");
        }
      } else {
        if (true == el.classes.contains("topNavi")) {
          el.classes.remove("topNavi");
        }
      }
    });
  }

  final Router _router;
  AppComponent(this._router);
  onLogin(LoginDialog d) {
    d.open();
  }

  onLogout(LogoutDialog d) {
    d.open();
  }

  ngOnInit(){
    new Future((){
      try {
        js.JsObject n = js.context["adsbygoogle"];
        n.callMethod("push", [new js.JsObject.jsify({})]);
      } catch(e) {
        print("Failed to push adsense");
      }
    });
  }

}
