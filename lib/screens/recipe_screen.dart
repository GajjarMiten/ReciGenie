import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'details_screen.dart';

class RecipeScreen extends StatefulWidget {
  final String query;
  const RecipeScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final APP_KEY = "85296178232f4854122175a39f5834c3";
  final APP_ID = "f5799ad1";

  Future<List<dynamic>> getRecipes() async {
    print("---------------------------------------");
    final response = await http.get(Uri.parse(
        "https://api.edamam.com/search?q=${widget.query}&app_id=$APP_ID&app_key=$APP_KEY"));
    List<dynamic> res = json.decode(response.body)["hits"];
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: FutureBuilder(
        future: getRecipes(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final recipe = snapshot.data![index]["recipe"];
                return Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),

                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: recipe["image"] ??
                            "https://via.placeholder.com/150",
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          recipe["label"] ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsScreen(url: recipe["url"]),
                                ),
                              );
                            },
                            child: Text("View Recipe")),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
