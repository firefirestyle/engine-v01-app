library k07me.prop;

import 'dart:convert' as conv;

class MiniProp {
  Map<String, Object> _content;

  MiniProp() {
    _content= {};
  }

  MiniProp.fromMap(Map<String, Object> content) {
    _content = content;
  }

  factory MiniProp.fromByte(List<int> bytes, {errorIsThrow: false}) {
    if(bytes == null) {
      bytes = [];
    }
    var jsonText = conv.UTF8.decode(bytes, allowMalformed: true);
    return new MiniProp.fromString(jsonText, errorIsThrow: errorIsThrow);
  }

  MiniProp.fromString(String jsonText, {errorIsThrow: false}) {
    try {
      _content = conv.JSON.decode(jsonText);
    } catch (e) {
      if (errorIsThrow == true) {
        throw e;
      }
    }
    if (_content == null) {
      _content = {};
    }
  }

  String toJson({errorIsThrow: false}) {
    try {
      return conv.JSON.encode(_content);
    } catch(e){
      if(errorIsThrow == true) {
        throw e;
      } else {
        return conv.JSON.encode({});
      }
    }
  }


  Object getPropObject(String category, String key, Object defaultValue) {
    var categoryContainer = {};
    //
    // category
    if (category == null || category == "") {
      categoryContainer = _content;
    } else if (false == _content.containsKey(category)) {
      return defaultValue;
    } else {
      categoryContainer = _content[category];
    }
    //
    // key
    if (false == categoryContainer.containsKey(key)) {
      return defaultValue;
    }
    //
    var v = categoryContainer[key];
    if (v == null) {
      return defaultValue;
    }
    return v;
  }

  void setPropObject(String category, String key, Object defaultValue) {
    var categoryContainer = {};
    // category
    if (category == null || category == "") {
      categoryContainer = _content;
    } else {
      categoryContainer = _content[category];
      if(categoryContainer == null) {
        categoryContainer = _content[category] = {};
      }
    }
    categoryContainer[key] = defaultValue;
  }

  String getString(String key, String defaultValue) {
    return getPropString(null, key, defaultValue);
  }

  num getNum(String key, num defaultValue) {
    return getPropNum(null, key, defaultValue);
  }

  num getPropNum(String category, String key, num defaultValue) {
    var v = getPropObject(category, key, defaultValue);
    if (v is num || v is int || v is double) {
      return v;
    } else {
      return defaultValue;
    }
  }

  String getPropString(String category, String key, String defaultValue) {
    var v = getPropObject(category, key, defaultValue);
    if (v is String) {
      return v;
    } else {
      return defaultValue;
    }
  }

  void setString(String key, String value) {
    setPropObject(null, key, value);
  }

  void setNum(String key, num value) {
    setPropObject(null, key, value);
  }

  void setPropString(String category, String key, String value) {
    setPropObject(category, key, value);
  }

  void setPropNum(String category, String key, num value) {
    setPropObject(category, key, value);
  }

  void setPropStringList(String category, String key, List<String> value) {
    setPropObject(category, key, value);
  }


  List<String> getPropStringList(String category, String key, List<String> defaultValue) {
    var v = getPropObject(category, key, defaultValue);
    if (v is List) {
      for(var vv in v) {
        if(!(vv is String)) {
          return defaultValue;
        }
      }
      return v;
    } else {
      return defaultValue;
    }
  }

  List<num> getPropNumList(String category, String key, List<num> defaultValue) {
    var v = getPropObject(category, key, defaultValue);
    if (v is List) {
      for(var vv in v) {
        if(!(vv is num || vv is double || vv is int)) {
          return defaultValue;
        }
      }
      return v;
    } else {
      return defaultValue;
    }
  }
}
