import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsScreen extends StatefulWidget {
  final String url;
  const DetailsScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Enable virtual display.
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            WebView(
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "https://" +
                  widget.url
                      .replaceAll("https://", "")
                      .replaceAll("http://", ""),
            ),
            (isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
