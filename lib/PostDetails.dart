import 'dart:io';

import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  PostDetails({Key key, this.jsonObj}) : super(key: key);
  var jsonObj;

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Title:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          Text(
            widget.jsonObj['title'],
            //'Note Title',
            style: TextStyle(fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Price:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          Text(
            widget.jsonObj['price'],
            //'Note Title',
            style: TextStyle(fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          Text(
            widget.jsonObj['desc'],
            //'Note Title',
            style: TextStyle(fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Image:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          Container(
            height: 200,
            width: 200,
            child: Image(
                image: FileImage(new File(widget.jsonObj['imagePath']))),
          ),
        ],
      ),
    );
  }
}