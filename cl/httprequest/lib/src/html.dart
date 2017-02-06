part of htmlver;

class Html5NetBuilder extends NetBuilder {
  Future<Requester> createRequester() async {
    return new Html5Requester();
  }
}

class Html5Requester extends Requester {
  Future<Response> request(String type, String url, {Object data: null, Map<String, String> headers: null}) {
    if (headers == null) {
      headers = {};
    }
    Completer<Response> c = new Completer();
    try {
      html.HttpRequest req = new html.HttpRequest();
      req.open(type, url, async: true);
      req.responseType = "arraybuffer";
      for (String k in headers.keys) {
        req.setRequestHeader(k, headers[k]);
      }

      req.onReadyStateChange.listen((e) {
        if (req.readyState == html.HttpRequest.DONE) {
          Map<String,List<String>> headerss = {};
          for(String key in req.responseHeaders.keys) {
            headerss[key] = [req.responseHeaders[key]];
          }
          c.complete(new Response(req.status, headerss, req.response));
        }
      });
      req.onError.listen((html.ProgressEvent e) {
        c.completeError(e);
      });
      if (data == null) {
        req.send();
      } else {
        req.send(data);
      }
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

//  Future<Object> srcToMultipartData(String src) {
//    List<int> v1 = conv.BASE64.decode(src);
//    html.Blob b = new html.Blob([v1], "image/png");
//    var fd = new html.FormData();
//    fd.appendBlob("file", b);
//    return fd;
//  }
}
