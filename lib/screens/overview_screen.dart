import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'recipe_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  String _lastWords = '';
  bool isListening = false;

  List<String> words = ["Tap", "on", "mic", "to", "start", "speaking"];

  void _initSpeech() async {
    try {
      await _speechToText.initialize().then((value) {
        setState(() {
          print(value);
          speechEnabled = value;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    Permission.microphone.request().then((value) {
      if (value.isGranted) {
        _initSpeech();
      }
    });
  }

  void _startListening() async {
    setState(() {
      isListening = true;
    });
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    setState(() {
      words = _lastWords.split(' ');
    });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isListening = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Mama'),
        leading: Icon(Icons.menu),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Color(0xffD3CEDF),
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: words
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          label: Text(
                            e + "\t",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: isListening
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        )),
                    child: Icon(
                      !isListening ? Icons.mic_off : Icons.mic,
                      color: !isListening
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  isListening ? "Listening" : "Not Listening",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_lastWords.isNotEmpty) {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (ctx) {
                            return RecipeScreen(
                              query: words.join(" "),
                            );
                          },
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("Please speak something"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("Search Recipes"),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
