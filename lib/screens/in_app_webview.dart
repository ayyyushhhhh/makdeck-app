import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class InAppwebView extends StatelessWidget {
  final String url;
  double progress = 0;
  final String urlType;

  InAppwebView({Key? key, required this.url, required this.urlType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(urlType),
        ),
        body: Column(children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
              onLoadStop: (controller, url) async {
                await controller.evaluateJavascript(source: "var foo = 49;");
                await controller.evaluateJavascript(
                    source: "var bar = 19;", contentWorld: ContentWorld.PAGE);

                // await controller.evaluateJavascript(
                //     source: "window.top.document.body.innerHTML = 'Hello';",
                //     contentWorld: ContentWorld.world(name: "MyWorld"));
              },
              onConsoleMessage: (controller, consoleMessage) {},
            ),
          ),
        ]),
      ),
    );
  }
}
