library firefirestyle.location.a;

class Location {
  String _href = "";
  String _hash = "";
  String _baseAddress = "";
  String _scheme = "";
  String _hostWithPort = "";
  String _path = "";
  String _hashPath;
  int _port = 80;
  String _host = "";

  Map<String, String> _values = {};
  Map<String, String> _urlValues = {};
  Map<String, String> _hashValues = {};
  String get href => _href;
  String get scheme => _scheme;
  String get hash => _hash;
  String get hostWithPort => _hostWithPort;
  String get host => _host;
  int get port => _port;
  String get path => _path;
  String get withSchemeHostPath => _baseAddress;
  String get baseAddr => "${scheme}://${hostWithPort}";
  String get baseAddrWithPath => baseAddr + path;
  String get hashPath => _hashPath; //
  Map<String, String> get values => _values;
  Map<String, String> get urlValues => _urlValues;
  Map<String, String> get hashValues => _hashValues;

  String getValueAsString(String key, String defaultValue) {
    var v = _values[key];
    return (v == null ? defaultValue : v);
  }

  int getValueAsInt(String key, int defaultValue) {
    var v = _values[key];
    if (v == null) {
      return defaultValue;
    }
    try {
      return int.parse(v);
    } catch (e) {
      return defaultValue;
    }
  }

  Location.fromHref(String href) {
    {
      this._href = href;
      int hashSt = href.indexOf("#");
      this._hash = hashSt == -1 ? "": href.substring(hashSt);
    }
    {
      var addr = _href.replaceFirst(new RegExp("[#\?].*"), "");
      this._baseAddress = addr;//.replaceFirst(new RegExp(r"/[^/]*$"), "/");
    }
    {
      this._scheme = this._baseAddress.replaceFirst(new RegExp(r"://.*$"), "");
    }
    {
      var v = this._baseAddress.replaceFirst(new RegExp(r".*://"), "");
      this._hostWithPort = v.replaceFirst(new RegExp(r"/.*"), "");
    }
    {
      String por = hostWithPort.replaceAll(new RegExp(r".*:"), "");
      if(por == "") {
        _port = 80;
      } else {
        try {
          _port = int.parse(por);
        }catch(e){
          _port = 80;
        }
      }
      _host =  hostWithPort.replaceAll(new RegExp(r":.*"), "");
    }
    {
      this._path = this._baseAddress.replaceFirst(this.scheme+"://", "").replaceFirst(this.hostWithPort, "");
//      this._path = this._baseAddress.replaceFirst(new RegExp(r".*/"), "/");
    }
    {
      var prop1 = _hashValues = _prop(_hash);
      var prop2 = _urlValues = _prop(_href.split("#")[0]);
      for (String key in prop1.keys) {
        _values[key] = prop1[key];
      }
      for (String key in prop2.keys) {
        _values[key] = prop2[key];
      }
    }
    {
      int end = _hash.indexOf("?");
      end = (end == -1 ? _hash.length : end);
      _hashPath = _hash.substring(0, end);
    }
  }

  Map<String, String> _prop(String hash) {
    if (hash == null) {
      return {};
    }
    Map<String, String> prop = {};
    if (hash.indexOf("?") > 0) {
      prop = Uri.splitQueryString(hash.substring(hash.indexOf("?") + 1));
    }
    return prop;
  }
}
