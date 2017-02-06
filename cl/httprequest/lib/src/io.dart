part of iover;

class IONetBuilder extends NetBuilder {
  Future<Requester> createRequester() async {
    return new IORequester();
  }
}

class IORequester extends Requester {
  Future<Response> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    print("[A1] ${type} ${url} ${headers} ${data}");
    io.HttpClient client = new io.HttpClient(context: io.SecurityContext.defaultContext);

    print("[A2]");
    io.HttpClientRequest req = await client.openUrl(type, Uri.parse(url));

    print("[A3]");
    for (String k in headers.keys) {
      req.headers.add(k, headers[k]);
    }
    req.followRedirects = true;
    if (data != null) {
      req.write(data);
    }
    print("[A4]");
    io.HttpClientResponse res = await req.close();

    print("[A5]");
    Map<String, List<String>> headerss = {};
    res.headers.forEach((String name, List<String> values) {
      headerss[name] = new List.from(values);
    });

    print("[A6] ${res}");
    var v = await res.single;
    print("[A7]");
    var ret = new Response(res.statusCode, headerss, new typed.Uint8List.fromList(v).buffer);
    print("[A8]");
    return ret;
  }
}
