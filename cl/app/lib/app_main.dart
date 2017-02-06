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

@Component(
  selector: "my-app",
  directives: const [LoginDialog, UserPage, UsersPage, LogoutDialog, PostArticlePage,ROUTER_DIRECTIVES],
  providers: const [ROUTER_PROVIDERS],
  template: """
  <header>
  <nav class='myul'>

  <div *ngIf='useHome==true'>
  <a class='myli' [routerLink]="['Arts']">Home</a>
  </div>
  <div *ngIf='useUsers==true'>
  <a class='myli' [routerLink]="['Users']">Users</a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='myli' [routerLink]="['Me']">Me</a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='myli' [routerLink]="['User',{name:rootConfig.cookie.userName}]">Me</a>
  </div>

  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='mylr' (click)='onLogin(myDialoga)'>Login</a>
  </div>
    <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='mylr' [routerLink]="['Post']">New</a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='mylr' (click)='onLogout(myLogoutDialoga)'>Logout</a>
  </div>
  </nav>
  </header>
  <main style='clear:both;'>main</main>
  <br>
  <router-outlet></router-outlet>
  <hooter>hooter</hooter>

  <my-login-dialog [name]="'as'" #myDialoga>
  </my-login-dialog>
   <my-logout-dialog [name]="'as'" #myLogoutDialoga>
  </my-logout-dialog>
  """,
  styles: const ["""
  .myul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    width: 600px;
    height: 34px;
    background-color: #f1f1f1;
 #   border: 1px solid #555;
  }
  @media (max-width: 600px) {
    .myul {
      width:100%;
     }
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
    padding: 8px 2px;
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
