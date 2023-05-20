import 'package:flutter/material.dart';
import 'package:flutter_app/screens/story_detail.dart';

import '../main.dart';
import '../model.dart';

class StoryLoadScreen extends StatefulWidget {
  final Story story;
  const StoryLoadScreen({required this.story, super.key});

  @override
  State<StoryLoadScreen> createState() => _StoryLoadScreenState();
}

class _StoryLoadScreenState extends State<StoryLoadScreen> {
  List<dynamic> options = [];
  List<dynamic> sections = [];

  @override
  void initState() {
    super.initState();
    client
        .from('story_choices')
        .select()
        .eq('story_id', widget.story.id)
        .order('option', ascending: true)
        .then((value) {
      value.forEach((item) {
        options.add(item);
      });
      setState(() {
        options = options;
      });
    });

    client
        .from('story_sections')
        .select()
        .eq('story_id', widget.story.id)
        .then((value) {
      value.forEach((item) {
        sections.add(item);
      });
      setState(() {
        sections = sections;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sections.isNotEmpty && options.isNotEmpty) {
      return StoryDetailScreen(
        story: widget.story,
        options: options,
        sections: sections,
        sectionId: widget.story.firstId,
      );
    }

    return Scaffold(
        backgroundColor: hexToColor(widget.story.color),
        body: const Center(
            child: CircularProgressIndicator(color: Colors.black)));
  }
}
