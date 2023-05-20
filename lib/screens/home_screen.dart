import 'package:flutter/material.dart';
import 'package:flutter_app/screens/story_detail.dart';
import 'package:flutter_app/screens/story_loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../blend_mask.dart';
import '../main.dart';
import '../model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<PostgrestResponse<dynamic>> _future = client
      .from('stories')
      .select(
          'id,title,cover,possibilities,color,story_sections:first(id,text)')
      .eq("published", true)
      .execute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: hexToColor("#f2eee5"),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Decision Tales",
            style: TextStyle(
                color: Colors.black,
                letterSpacing: -1.0,
                fontWeight: FontWeight.w800),
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var response = snapshot.data as PostgrestResponse<dynamic>;
              List<Story> stories = [];
              response.data.forEach((item) {
                var card = Story.fromJson(item);
                stories.add(card);
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text("New Stories".toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 15,
                              letterSpacing: -0.4,
                              fontWeight: FontWeight.w700,
                              height: 1.5))),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 360,
                      child: ListView.builder(
                          itemCount: stories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    border: Border.all(color: Colors.black54),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 15,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 15),
                                  width: 300,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12))),
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(20),
                                            child: Center(
                                                child: Container(
                                                    width: 145,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.6),
                                                          spreadRadius: 2,
                                                          blurRadius: 14,
                                                          offset: const Offset(
                                                              0,
                                                              8), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: ImageMixer(
                                                        imageUrl: stories[index]
                                                            .cover)))),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Text(stories[index].title,
                                            style: TextStyle(
                                              color: Colors.grey.shade900,
                                              fontSize: 15,
                                              letterSpacing: -0.4,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                            "${stories[index].possibilities} possible endings",
                                            style: TextStyle(
                                              color: Colors.grey.shade900,
                                              fontSize: 13,
                                              letterSpacing: -0.2,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                              onTap: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StoryLoadScreen(story: stories[index])),
                              ),
                            );
                          })),
                ],
              );
            } else {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            }
          },
        ));
  }
}
