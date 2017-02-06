part of firestyle.cl.netbox;

class UploadFileProp {
  pro.MiniProp prop;
  UploadFileProp(this.prop) {}

  String get blobKey => prop.getString("blobkey", "");
}

class FileNBox {
  req.NetBuilder builder;
  String backAddr;
  String callbackopt = "cb";
  FileNBox(this.builder, this.backAddr) {}

  Future<String> getBlobFromKey(String key) async {
    return "${backAddr}/api/v1/blob/get?key=${Uri.encodeComponent(key)}";
  }

  Future<UploadFileProp> updateFile(String accessToken, String dir, String name, typed.Uint8List data) async {
    String url = [
      backAddr, //
      """/api/v1/blob/requesturl""", //
      """?dir=${Uri.encodeComponent(dir)}&file=${Uri.encodeComponent(name)}"""
    ].join("");

    var uelPropObj = new pro.MiniProp();
    uelPropObj.setString("token", accessToken);
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
