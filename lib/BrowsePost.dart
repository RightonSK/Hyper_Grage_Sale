import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/MiscParameters.dart';
import 'package:hyper_garage_sale/PostCollection.dart';
import 'package:hyper_garage_sale/PostDetails.dart';

class BrowsePostPage extends StatefulWidget {
  @override
  _BrowsePostPageState createState() => _BrowsePostPageState();
}

class _BrowsePostPageState extends State<BrowsePostPage> {
  PostStorage ps = PostStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Browse Post")),
      body: Center(
        child: FutureBuilder(
          future: ps.readPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 'na') {
              print("No posts found in the file");
              return Text("There are no posts");
            }
            // Decode the JSON
            var _tempPostList = json.decode(snapshot.data.toString());
            _tempPostList = new List.from(_tempPostList.reversed);
            print("From file: " + snapshot.data.toString());

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 32, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PostDetails(
                                              jsonObj: _tempPostList[index],
                                            )));
                              }, // onTap logic is one of the item (#2) of final project
                              child: Text(
                                _tempPostList[index]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(
                              _tempPostList[index]['price'],
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Image(
                              image: FileImage(
                                  new File(_tempPostList[index]['imagePath']))),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _tempPostList == null ? 0 : _tempPostList.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MiscParameters.tempImagePath = '';
          // Navigate to the new post screen using a named route.
          Navigator.pushNamed(context, '/newpost');
        },
        tooltip: 'New Post',
        child: Icon(Icons.add),
      ),
    );
  }
}
