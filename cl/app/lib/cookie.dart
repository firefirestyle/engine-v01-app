import 'package:cookie/cookie.dart' as cookie;

class Cookie {
  Map<String, String> binary = {};
  String getValue(String key, String defaultValue) {
    if (binary.containsKey(key)) {
      return binary[key];
    }
    var v = cookie.get(key);
    return (v == null?defaultValue:v);
  }

  void setValue(String key, String v) {
    if (v == null) {
      v = "";
    }
    binary[key] = v;
    cookie.set(key, v);
  }
}


class MyCookie extends Cookie {
  static final String keyAccessToken = "user-accesstoken";
  static final String keyUserName = "user-name";
  static final String keyIsMaster = "user-isMaster";

  String get accessToken => getValue(keyAccessToken, "");

  String get userName =>getValue(keyUserName, "");

  int get isMaster {
    var v = getValue(keyIsMaster, "");
    try {
      return int.parse(v);
    } catch (e) {
      return 0;
    }
  }

  bool get isLogin => (accessToken != null && accessToken.length != 0);

  void init() {}

  void set userName(String v) {
    if (v == null) {
      v = "";
    }
    binary[keyUserName] = v;
    cookie.set(keyUserName, v);
  }

  void setIsMaster(String value) {
    setValue(keyIsMaster,  value);
  }

  void set isMaster(int value) {
    setValue(keyIsMaster,"${value}");
  }

  void set accessToken(String v) {
    setValue(keyAccessToken,v);

  }
}