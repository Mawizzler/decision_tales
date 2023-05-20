class Story {
  Story({
    required this.id,
    required this.title,
    required this.firstId,
    required this.intro,
    required this.cover,
    required this.possibilities,
  });

  int id;
  String title;
  int firstId;
  String intro;
  String cover;
  int possibilities;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
      id: json["id"],
      title: json["title"],
      firstId: json["story_sections"]["id"],
      intro: json["story_sections"]["text"],
      possibilities: json["possibilities"] ?? 0,
      cover: json["cover"] ?? "");
}
