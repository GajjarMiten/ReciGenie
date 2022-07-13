import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  List<String> words = [];

  void _initSpeech() async {
    try {
      await _speechToText.initialize().then((value) {
        setState(() {
          print("Speech to text initialized");
          print(value);
          speechEnabled = value;
        });
      });
    } catch (e) {
      print("------------------");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    Permission.microphone.request().then((value) {
      print(value.isGranted);
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
      floatingActionButton: FloatingActionButton.extended(
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
        label: Text("Search Recipe"),
        icon: Icon(Icons.search),
      ),
      appBar: AppBar(
        title: Text(
          'Food Mama',
          style: TextStyle(color: Colors.black),
        ),
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffeceff9),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
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
                          ? Color.fromARGB(255, 255, 67, 53)
                          : Color.fromARGB(129, 184, 184, 184),
                      boxShadow: [
                        BoxShadow(
                          color: isListening
                              ? Colors.pink.withOpacity(0.2)
                              : Colors.transparent,
                          spreadRadius: 8,
                          blurRadius: 20,
                          offset: Offset(0, 3),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      !isListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: words.length > 0
                  ? Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.horizontal,
                      children: words
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Chip(
                                label: Text(
                                  e + "\t",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                          .toList())
                  : Column(
                      children: [
                        Text("Click in the Mic to start Speaking"),
                        Lottie.network(
                            "https://assets4.lottiefiles.com/packages/lf20_rjcm4jcc.json",
                            height: 300)
                      ],
                    ),
            ),
            
          ],
        ),
      ),
    );
  }
}
