import 'package:flutter/material.dart';
import 'package:flutter_app/screens/story_loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      .select('id,title,cover,possibilities,story_sections:first(id,text)')
      .eq("published", true)
      .execute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.grey.shade200,
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(27, 158, 158, 158), width: 1)),
          title: const Text(
            "Decision Tales",
            style: TextStyle(color: Colors.black),
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
                  Expanded(
                      child: ListView.builder(
                          itemCount: stories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15),
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Image.network(
                                            stories[index].cover)),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(stories[index].title),
                                     Text("${stories[index].possibilities} possible endings")
                                  ])),
                              onTap: () =>  Navigator.of(context, rootNavigator: true)
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
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ));
  }
}
