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
import 'page_user.dart';
import 'page_users.dart';
import 'page_post_art.dart';
import 'comp_post_art.dart';
import 'dart:html' as html;
import 'package:angular2_components/angular2_components.dart';

@Component(
  selector: "my-app",
  directives: const [LoginDialog, UserPage, UsersPage, LogoutDialog, PostArticlePage,ROUTER_DIRECTIVES,materialDirectives],
  providers: const [ROUTER_PROVIDERS],
  template: """
  <div>
  FireFireStyle 炎の型工房
  </div>
  <header class='myhe' #headera>
  <nav class='myul'>
  <div *ngIf='useHome==true'>
  <a class='myli' [routerLink]="['Arts']"><glyph icon="home"></glyph><br><div style='font-size:6px;'>Home</div></a>
  </div>
  <div *ngIf='useUsers==true'>
  <a class='myli' [routerLink]="['Users']"><glyph icon="group"></glyph><br><div style='font-size:6px;'>User</div></a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='myli' [routerLink]="['Me']"><glyph icon="face"></glyph><br><div style='font-size:6px;'>Me</div></a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='myli' [routerLink]="['User',{name:rootConfig.cookie.userName}]"><glyph icon="face"></glyph><br><div style='font-size:6px;'>Me</div></a>
  </div>

  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='mylr' (click)='onLogin(myDialoga)'><glyph icon="flag"></glyph><br><div style='font-size:6px;'>Login</div></a>
  </div>
    <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='mylr' [routerLink]="['Post']"><glyph icon="add_box"></glyph><br><div style='font-size:6px;'>New</div></a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='mylr' (click)='onLogout(myLogoutDialoga)'><glyph icon="undo"></glyph><br><div style='font-size:6px;'>Logout</div></a>
  </div>
  </nav>
  </header>  <br><br>
  <main class='main'><br>
  <router-outlet></router-outlet>
  </main>
  <footer style='background-color:#555; font:#000000'>
  <div style='color:#ffffff;'>
  MAIL: <a style='color:#ffffff;' href="kyorohiro@firefirestyle.net">kyorohiro@firefirestyle.net</a>
  </div>
  <div style='color:#ffffff;'>
  Blog: <a style='color:#ffffff;' href="http://blogger.firefirestyle.net">http://blogger.firefirestyle.net</a>
  </div>
  <div style='color:#ffffff;'>
  Twitter: <a style='color:#ffffff;' href="https://twitter.com/firefirestyle">https://twitter.com/firefirestyle</a>
  </div>
  </footer>

  <my-login-dialog [name]="'as'" #myDialoga>
  </my-login-dialog>
   <my-logout-dialog [name]="'as'" #myLogoutDialoga>
  </my-logout-dialog>

  """,
  styles: const ["""
  .main {
    clear:both;
    min-height:800px;
  }
  .myul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    width: 600px;
#    //height: 34px;

 #   border: 1px solid #555;
  }
  .myhe {
      position: absolute;
      width: 600px;
    z-index: 999;
        background-color: #f1f1f1;
   }
  @media (max-width: 600px) {
    .myul {
      width:100%;
     }
     .myhe {
      width:90%;
     }
  }
  .topNavi {
    position: fixed;
    top: 0;
    z-index: 999;
  }
  .myli {
    display: block;
    float: left;
    font-size: 16px;
    color: #000000;
    text-decoration: none;
    padding: 8px 16px;
    margine: 1px;
    text-align: center;
    border: 1px solid #555;
  }
  .myli .selected {
    background-color: #4CAF50;
    color: white;
  }
  .myli:hover {
    background-color: #555;
    color: white;
  }
  .mylr {
    display: block;
    float: right;
    font-size: 16px;
    color: #ffffff;
    text-decoration: none;
    padding: 8px 16px;
    margine: 1px;
    text-align: center;
    border: 1px solid #ffffff;
    background-color: #555;
  }
  """],
)
@RouteConfig( const[
  const Route(
      path: "/",
      name: "Arts",
      component: ArtsPage,
      useAsDefault: true),
  const Route(
      path: "/users",
      name: "Users",
      component: UsersPage,
      useAsDefault: false),
  const Route(
      path: "/me",
      name: "Me",
      component: MeComponent,
      data: const {"page":"me"},
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
]
)
class AppComponent implements OnInit {
  bool useHome = true;
  bool useMe = true;
  bool useUsers = true;
  config.AppConfig rootConfig = config.AppConfig.inst;


  @ViewChild('headera')
  set header(ElementRef elementRef) {

    html.Element el = elementRef.nativeElement;
    html.window.onScroll.listen((e){
      if(html.window.scrollY > 100) {
        print(">>A ${html.window.scrollY  }");

        if(false == el.classes.contains("topNavi")){
          el.classes.add("topNavi");
        }
      } else {
        print(">>B ${html.window.scrollY  }");

        if(true == el.classes.contains("topNavi")){
          el.classes.remove("topNavi");
        }
      }
    });

  }
  AppComponent(){
  }
  onLogin(LoginDialog d) {
    d.open();
  }
  onLogout(LogoutDialog d) {
    d.open();
  }

  ngOnInit() {
  }
}
