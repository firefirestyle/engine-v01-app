part of httprequest;

class MultipartItem {
  String name;
  String fileName;
  String contentType;
  typed.ByteBuffer buffer;

  // "data:image/png:base64,xxxxx..."
  factory MultipartItem.fromBase64(String name, String fileName, String contentType, String base64Src) {
    return new MultipartItem.fromList(name, fileName, contentType, BASE64.decode(base64Src));
  }

  MultipartItem.fromList(this.name, this.fileName, this.contentType, List<int> data) {
    if(data is typed.Uint8List) {
      buffer = data.buffer;
    } else {
      buffer = new typed.Uint8List.fromList(data).buffer;
    }
  }

  MultipartItem.fromByteBuffer(this.name, this.fileName, this.contentType, this.buffer) {
  }

  List<List<int>> toBytesList() {
    List<List<int>> bufferList = [];
    bufferList.add(ASCII.encode("""Content-Disposition: form-data; name="${name}"; filename="${fileName}"\r\n"""));
    bufferList.add(ASCII.encode("""Content-Type: ${contentType}\r\n"""));
    bufferList.add(ASCII.encode("""\r\n"""));
    bufferList.add(buffer.asUint8List());
    return bufferList;
  }
}

//
// todo. dart:html version should use formdata class or blob
//
class Multipart {
  Future<Response> post(Requester requester, String url, List<MultipartItem> items) async {
    String boundary = "----" + Uuid.createUUID().replaceAll("-", "");
    return await requester.request(Requester.TYPE_POST, url, //
        data: bakeMultiPartFromBinary(boundary, items), //
        headers: {"Content-Type": """multipart/form-data; boundary=${boundary}"""});
  }

  List<int> bakeMultiPartFromBinary(String boundary, List<MultipartItem> items) {
    List<List<int>> buffer = [];
    buffer.add(ASCII.encode("""--${boundary}\r\n"""));
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      buffer.addAll(item.toBytesList());
      buffer.add(ASCII.encode("""\r\n"""));
      buffer.add(ASCII.encode("""--${boundary}${i==items.length-1?"--":""}\r\n"""));
    }
    buffer.add(ASCII.encode("""\r\n"""));

    int length = 0;
    for (var b in buffer) {
      length += b.length;
    }
    var index = 0;
    var byteBuffer = new typed.Uint8List(length);
    for (var b in buffer) {
      byteBuffer.setAll(index, b);
      index += b.length;
    }
    return byteBuffer;
  }
/*
  Future<Object> srcToMultipartData(String src) {
    List<int> v1 = BASE64.decode(src);
    html.Blob b = new html.Blob([v1], "image/png");
    var fd = new html.FormData();
    fd.appendBlob("file", b);
    return fd;
  }
  */
}
