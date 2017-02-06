import 'dart:async';
import 'dart:html' as html;

class ImageUtil {
  static Future<html.ImageElement> loadImage(html.File imgFile) async {
    Completer<html.ImageElement> co = new Completer();
    html.CanvasElement canvas = new html.CanvasElement();
    html.FileReader r = new html.FileReader();
    html.ImageElement imageTmp = new html.ImageElement();

    r.onLoad.listen((html.ProgressEvent e) {
      html.CanvasRenderingContext2D c = canvas.context2D;
      imageTmp.onLoad.listen((html.Event e) {
        c.drawImageToRect(
            imageTmp, new html.Rectangle(0, 0, canvas.width, canvas.height),
            sourceRect: new html.Rectangle(
                0, 0, imageTmp.width, imageTmp.height));
        co.complete(imageTmp);
      });
      imageTmp.onError.listen((html.Event e) {
        co.completeError(e);
      });

      imageTmp.src = r.result;
    });
    r.readAsDataUrl(imgFile);

    return co.future;
  }

  static Future<html.ImageElement> resizeImage(html.ImageElement imageTmp,
      {int nextHeight: -1,int nextWidth: 300,}) async {
    html.CanvasElement canvasElm = new html.CanvasElement();
    html.CanvasRenderingContext2D context = canvasElm.context2D;
    if(nextWidth > 0) {
      canvasElm.width = nextWidth;
      canvasElm.height = ((nextWidth * imageTmp.height) ~/ imageTmp.width);
    } else if(nextHeight > 0) {
      canvasElm.width = ((nextHeight * imageTmp.width) ~/ imageTmp.height);
      canvasElm.height = nextHeight;
    } else {
      canvasElm.width = 300;
      canvasElm.height = 300;
    }

    context.drawImageToRect(imageTmp, new html.Rectangle(0, 0, canvasElm.width, canvasElm.height), sourceRect: new html.Rectangle(0, 0, imageTmp.width, imageTmp.height));
    html.ImageElement ret = new html.ImageElement();
    ret.src = canvasElm.toDataUrl();
    ret.width = (nextHeight * imageTmp.width ~/ imageTmp.height).toInt();
    ret.height = nextHeight;
    print("##<ZZZZZ>#${ret.width} ${ret.height} ${canvasElm.width}, ${canvasElm.height}");
    return ret;
  }
}
