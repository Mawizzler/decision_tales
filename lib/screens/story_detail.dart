import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class StoryDetailScreen extends StatefulWidget {
  final Story story;
  final List<dynamic> options;
  final List<dynamic> sections;
  final int sectionId;

  const StoryDetailScreen(
      {required this.story,
      required this.options,
      required this.sections,
      required this.sectionId,
      super.key});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  List<dynamic> currentOptions = [];
  List<dynamic> currentSections = [];
  int idInView = 0;
  var currentPosition = {
    "left": 0.0,
    "top": 0.0,
  };

  @override
  void initState() {
    super.initState();
    var first = widget.sections
        .firstWhere((element) => element["id"] == widget.story.firstId);
    first["position"] = {"left": 0.0, "top": 0.0};
    first["scale"] = 1.0;
    first["options"] = widget.options
        .where((element) => element["from_id"] == widget.sectionId)
        .toList();

    currentSections.add(first);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              title: Text(
                widget.story.title,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.w800),
              ),
              actions: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashRadius: null,
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
              leading: const Text(""),
            ),
            backgroundColor: hexToColor(widget.story.color),
            body: Stack(children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                left: currentPosition["left"],
                top: currentPosition["top"],
                width: 60000,
                height: 60000,
                curve: Curves.easeIn,
                child: Stack(children: [
                  for (var item in currentSections)
                    Positioned(
                        left: item["position"]["left"] ?? 0.0,
                        top: item["position"]["top"] ?? 0.0,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.bottom,
                        child: SingleChildScrollView(
                            child: SafeArea(
                                child: AnimatedScale(
                          duration: const Duration(milliseconds: 400),
                          scale: item["scale"] ?? 1.0,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
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
                              padding: const EdgeInsets.all(25),
                              margin: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  Text(
                                    item["text"],
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 19,
                                        letterSpacing: -0.2,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5),
                                  ),
                                  if (item["options"].length > 0)
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25, bottom: 20),
                                        child: Text(
                                          "What happens next?".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 15,
                                              letterSpacing: -0.4,
                                              fontWeight: FontWeight.w700,
                                              height: 1.5),
                                        )),
                                  if (item["options"].length > 0)
                                    OptionButton(
                                      position: "right",
                                      option: item["options"][0],
                                      onPressed: () {
                                        var next = widget.sections.firstWhere(
                                            (element) =>
                                                element["id"] ==
                                                item["options"][0]["to_id"]);

                                        next["position"] = {
                                          "left": item["position"]["left"] +
                                              MediaQuery.of(context).size.width,
                                          "top": item["position"]["top"] + 0.0,
                                        };
                                        next["options"] = widget.options
                                            .where((element) =>
                                                element["from_id"] ==
                                                next["id"])
                                            .toList();

                                        setState(() {
                                          currentSections.add(next);
                                          currentPosition = {
                                            "left": -next["position"]["left"],
                                            "top": -next["position"]["top"],
                                          };
                                          item["scale"] = 0.8;
                                          currentSections[currentSections
                                              .indexWhere((element) =>
                                                  element["id"] ==
                                                  item["id"])] = item;
                                        });
                                      },
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (item["options"].length > 0)
                                    OptionButton(
                                      position: "left",
                                      option: item["options"][1],
                                      onPressed: () {
                                        var next = widget.sections.firstWhere(
                                            (element) =>
                                                element["id"] ==
                                                item["options"][1]["to_id"]);

                                        next["position"] = {
                                          "left":
                                              item["position"]["left"] + 0.0,
                                          "top": item["position"]["top"] +
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                        };
                                        next["options"] = widget.options
                                            .where((element) =>
                                                element["from_id"] ==
                                                next["id"])
                                            .toList();

                                        setState(() {
                                          currentSections.add(next);
                                          currentPosition = {
                                            "left": -next["position"]["left"],
                                            "top": -next["position"]["top"],
                                          };
                                          item["scale"] = 0.8;
                                          currentSections[currentSections
                                              .indexWhere((element) =>
                                                  element["id"] ==
                                                  item["id"])] = item;
                                        });
                                      },
                                    )
                                ],
                              )),
                        ))))
                ]),
              )
            ])));
  }
}

// ignore: must_be_immutable
class OptionButton extends StatelessWidget {
  dynamic option;
  Function onPressed;
  String position;
  OptionButton(
      {required this.option,
      required this.onPressed,
      required this.position,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.black)),
            padding: const EdgeInsets.all(15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (position == "left")
                    Container(
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        width: 40,
                        height: 40,
                        child: const Center(
                            child: Icon(
                          CupertinoIcons.arrow_down,
                          size: 20,
                        ))),
                  Expanded(
                    child: Text(option["text"],
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 15,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.w500,
                            height: 1.3)),
                  ),
                  if (position == "right")
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        width: 40,
                        height: 40,
                        child: const Center(
                            child: Icon(
                          CupertinoIcons.arrow_right,
                          size: 20,
                        ))),
                ])));
  }
}
