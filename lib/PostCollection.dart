import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PostCollection {
  static var _postList = new List<Post>();
  static PostStorage postStorage;

  PostCollection();

  static add(String t, String p, String d, String imagePath) {
    _postList.add(Post(t, p, d, imagePath));
    print("New post added: " + t + "\t" + p + "\t" + d);
    print("Length of the _postList is: " + _postList.length.toString());

    print(_postList.toString());
    print(jsonEncode(_postList));
    postStorage = PostStorage();
    postStorage.writePosts(jsonEncode(_postList));
  }
}

class Post {
  String title;
  String price;
  String desc;
  String imagePath;

  Post(String t, String p, String d, String ip) {
    this.title = t;
    this.price = p;
    this.desc = d;
    this.imagePath = ip;
  }

  Map toJson() => {
        'title': this.title,
        'price': this.price,
        'desc': this.desc,
        'imagePath': this.imagePath,
      };

  @override
  String toString() {
    return '{ ${this.title}, ${this.price}, ${this.desc}, ${this.imagePath} }';
  }
}

class PostStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/posts.txt');
  }

  Future<String> readPosts() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return na
      return 'na';
    }
  }

  Future<File> writePosts(String posts) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$posts');
  }
}
