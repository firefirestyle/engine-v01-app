part of httprequest;


abstract class NetBuilder {
  Future<Requester> createRequester();
}

abstract class Requester {
  static final String TYPE_POST = "POST";
  static final String TYPE_GET = "GET";
  static final String TYPE_PUT = "PUT";
  static final String TYPE_DELETE = "DELETE";
  Future<Response> request(String type, String url, {Object data: null, Map<String, String> headers: null});
  //Future<Object> srcToMultipartData(String src);
}

class Response {
  int _status;
  int get status => _status;
  ByteBuffer _response;
  ByteBuffer get response => (_response == null ? new Uint8List.fromList([]) : _response);
  Map<String, List<String>> _headers = {};
  Map<String, List<String>> get headers => _headers;
  Response(this._status, Map<String, List<String>> headers, this._response) {
    for(String key in headers.keys) {
      _headers[key] = new List.from(headers[key]);
    }
  }
}
