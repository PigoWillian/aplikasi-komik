class Chapter {
  final String id;
  final String path;
  final String name;
  final String view;
  final String createdAt;

  const Chapter({
    required this.id,
    required this.path,
    required this.name,
    required this.view,
    required this.createdAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      path: json['path'],
      name: json['name'] as String,
      view: json['view'],
      createdAt: json['createdAt'],
    );
  }
}
