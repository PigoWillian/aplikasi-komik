class ContentChapter {
  final String title;
  final String currentChapter;
  final List<ChapterListId> chapterListIds;
  final List<ImageData> images;

  ContentChapter({
    required this.title,
    required this.currentChapter,
    required this.chapterListIds,
    required this.images,
  });

  factory ContentChapter.fromJson(Map<String, dynamic> json) {
    var chapterListIdsFromJson = json['chapterListIds'] as List?;
    var imagesFromJson = json['images'] as List?;

    return ContentChapter(
      title: json['title'] ?? '',
      currentChapter: json['currentChapter'] ?? '',
      chapterListIds: chapterListIdsFromJson != null
          ? chapterListIdsFromJson
              .map((i) => ChapterListId.fromJson(i))
              .toList()
          : [],
      images: imagesFromJson != null
          ? imagesFromJson.map((i) => ImageData.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'currentChapter': currentChapter,
      'chapterListIds': chapterListIds.map((i) => i.toJson()).toList(),
      'images': images.map((i) => i.toJson()).toList(),
    };
  }
}

class ChapterListId {
  final String id;
  final String name;

  ChapterListId({required this.id, required this.name});

  factory ChapterListId.fromJson(Map<String, dynamic> json) {
    return ChapterListId(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ImageData {
  final String title;
  final String image;

  ImageData({required this.title, required this.image});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      title: json['title'] ?? '',
      image: json['image'] ?? '+',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
    };
  }
}
