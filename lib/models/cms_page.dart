class CmsPage {
  int id;
  String identifier;
  String title;
  String content;
  bool active;

  CmsPage({
    this.id = 0,
    this.identifier = "",
    this.title = "",
    this.content = "",
    this.active = false,
  });

  factory CmsPage.fromJson(Map<String, dynamic> json) => CmsPage(
        id: json["id"],
        identifier: json["identifier"],
        title: json["title"],
        content: json["content"],
        active: json["active"],
      );
}
