part of firestyle.cl.netbox;

class LogoutProp {
  pro.MiniProp prop;
  LogoutProp(this.prop) {}
}

class MeNBoxLoginCB {
  int permission;
  String token;
  String userName;
  String error;
}

class MeNBox {
  req.NetBuilder builder;
  String backAddr;
  String callbackopt = "cb";
  MeNBox(this.builder, this.backAddr) {}

  String makeLoginTwitterUrl(String callbackAddr) {
    return """${backAddr}/api/v1/twitter/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(callbackAddr)}""";
  }

  String makeLoginFacebookUrl(String callbackAddr) {
    return """${backAddr}/api/v1/facebook/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(callbackAddr)}""";
  }

  Future<String> createBlobUrlFromKey(String key, {String sign: ""}) async {
    if(key == "" || key == null) {
      return "";
    }
    key = key.replaceAll("key://", "");
    return [
      """${backAddr}/api/v1/user/getblob""", //
      """?key=${Uri.encodeComponent(key)}""", //
      """&sign=${Uri.encodeComponent(sign)}""",
    ].join("");
  }

  MeNBoxLoginCB getInfoFromLoginCallback(String url) {
    Uri urlObj = Uri.parse(url);
    var ret = new MeNBoxLoginCB();
    ret.token = urlObj.queryParameters["token"];
    ret.token = (ret.token == null ? "" : ret.token);
    ret.userName = urlObj.queryParameters["userName"];
    ret.userName = (ret.userName == null ? "" : ret.userName);
    ret.error = urlObj.queryParameters["error"];
    ret.error = (ret.error == null ? "" : ret.error);
    ret.permission = int.parse(urlObj.queryParameters["isMaster"], onError: (v) {
      return 0;
    });
    return ret;
  }

  Future<UserInfoProp> getMeInfo(String accessToken) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/me/get";
    var inputData = new pro.MiniProp();
    inputData.setString("token", accessToken);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserInfoProp> updateUserInfo(String accessToken, String userName, {String displayName: "", String cont: "", List<String> tags}) async {
    var requester = await builder.createRequester();
    var url = ["""${backAddr}/api/v1/me/update"""].join();
    var inputData = new pro.MiniProp();
    inputData.setString("token", accessToken);
    inputData.setString("userName", userName);
    inputData.setString("displayName", displayName);
    inputData.setString("content", cont);
    inputData.setPropStringList(null, "tags", tags);
    req.Response response = await requester.request(req.Requester.TYPE_POST, url, data: inputData.toJson());
    if (response.status != 200) {
      throw new ErrorProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
    }
    return new UserInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<LogoutProp> logout(String token) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/me/logout";
    var prop = new pro.MiniProp();
    prop.setString("token", token);

    req.Response response = await requester.request(req.Requester.TYPE_GET, url, data: prop.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw new Exception("");
    }
    return new LogoutProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UploadFileProp> updateIcon(String accessToken, typed.Uint8List data) async {
    return updateFile(accessToken, "", "meicon", data);
  }

  //
  //
  //
  Future<UploadFileProp> updateFile(String accessToken, String dir, String name, typed.Uint8List data, {String userName: ""}) async {
    String url = [
      backAddr, //
      """/api/v1/user/requestbloburl"""
    ].join("");

    var uelPropObj = new pro.MiniProp();
    uelPropObj.setString("token", accessToken);
    uelPropObj.setString("userName", userName);
    uelPropObj.setString("dir", dir);
    uelPropObj.setString("file", name);

    req.Response response = await (await builder.createRequester()).request(req.Requester.TYPE_POST, url, data: uelPropObj.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw "failed to get request token";
    }
    var responsePropObj = new pro.MiniProp.fromByte(response.response.asUint8List());
    var tokenUrl = responsePropObj.getString("token", "");
    var propName = responsePropObj.getString("name", "file");
    //new prop.MiniProp.fromByte(response.response.asUint8List());
    print(""" TokenUrl = ${tokenUrl} """);
    req.Multipart multipartObj = new req.Multipart();
    var responseFromUploaded = await multipartObj.post(await builder.createRequester(), tokenUrl, [
      new req.MultipartItem.fromList(propName, "blob", "image/png", data) //
    ]);
    if (responseFromUploaded.status != 200) {
      throw "failed to uploaded";
    }

    return new UploadFileProp(new pro.MiniProp.fromByte(responseFromUploaded.response.asUint8List(), errorIsThrow: false));
  }
}
