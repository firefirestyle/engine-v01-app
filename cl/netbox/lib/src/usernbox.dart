part of firestyle.cl.netbox;

//
//

class UserKeyListProp {
  pro.MiniProp prop;
  UserKeyListProp(this.prop) {}
  List<String> get keys => this.prop.getPropStringList(null, "keys", []);
  String get cursorOne => this.prop.getString("cursorOne", "");
  String get cursorNext => this.prop.getString("cursorNext", "");
}

class UserInfoProp {
  pro.MiniProp prop;
  UserInfoProp(this.prop) {}

  String get displayName => prop.getString("DisplayName", "");
  String get userName => prop.getString("UserName", "");
  int get created => prop.getNum("Created", 0);
  int get logined => prop.getNum("Logined", 0);
  String get state => prop.getString("State", "");
  num get point => prop.getNum("Point", 0);

  String get iconUrl => prop.getString("IconUrl", "");
  String get publicInfo => prop.getString("PublicInfo", "");
  String get privateInfo => prop.getString("PrivateInfo", "");
  String get sign => prop.getString("Sign", "");
  String get content => prop.getString("Cont", "");
  List<String> get pointName => prop.getPropStringList(null, "PointNames", []);
  List<num> get pointValues => prop.getPropNumList(null, "PointValues", []);
  List<String> get tagNames => prop.getPropStringList(null, "TagNames", []);
  List<String> get tagValues => prop.getPropStringList(null, "TagValues", []);
  num get permission => prop.getNum("Permission", 0);
}

class UserNBox {
  static const String modeNewOwder = "";
  static const String modeMPoint = "-point";
  req.NetBuilder builder;
  String backAddr;
  UserNBox(this.builder, this.backAddr) {}

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

  Future<String> createBlobUrl(String useName, String dir, String file, {String sign: ""}) async {
    return _makeUserBlob("", useName: useName, dir: dir, file: file, sign: sign);
  }

  Future<String> _makeUserBlob(String key, {String useName: "", String dir: "", String file: "", String sign: ""}) async {
    key = key.replaceAll("key://", "");
    return [
      """${backAddr}/api/v1/user/getblob""", //
      """?key=${Uri.encodeComponent(key)}""", //
      """&dir=${Uri.encodeComponent(dir)}""",
      """&file=${Uri.encodeComponent(file)}""",
      """&sign=${Uri.encodeComponent(sign)}""",
    ].join("");
  }

  //
  Future<UserInfoProp> getUserInfo(String userName, {String sign: ""}) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/user/get?userName=${Uri.encodeComponent(userName)}&sign=${Uri.encodeComponent(sign)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserInfoProp> getUserInfoFromKey(String key) async {
    var requester = await builder.createRequester();
    var url = "${backAddr}/api/v1/user/get?key=${Uri.encodeComponent(key)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UserKeyListProp> findUser(String cursor, {String group: "", String mode: "-update"}) async {
    var url = "${backAddr}/api/v1/user/find?mode=${Uri.encodeComponent(mode)}&group=${Uri.encodeComponent(group)}";
    var requester = await builder.createRequester();
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserKeyListProp(new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}
