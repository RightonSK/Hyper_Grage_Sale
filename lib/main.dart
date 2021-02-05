import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/BrowsePost.dart';
import 'package:hyper_garage_sale/MiscParameters.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'PostCollection.dart';

CameraController _controller;
Future<void> _initializeControllerFuture;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  // create a CameraController.
  _controller = CameraController(
    // Get a specific camera from the list of available cameras.
    firstCamera,
    // Define the resolution to use.
    ResolutionPreset.medium,
  );

  // Next, initialize the controller. This returns a Future.
  _initializeControllerFuture = _controller.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyperGarageSale',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: BrowsePostPage(),   // Not needed since '/' route is defined
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => BrowsePostPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/newpost': (context) => NewPostFormScreen(title: 'New Post'),
        // Hint: for part of the final project, you may want to consider defining '/postdetail' route here which takes user to PostDetailPage.
      },
    );
  }
}

class NewPostFormScreen extends StatefulWidget {
  NewPostFormScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _NewPostFormScreenState createState() => _NewPostFormScreenState();
}

class _NewPostFormScreenState extends State<NewPostFormScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: NewPostForm(),
    );
  }
}

// Create a Form widget.
class NewPostForm extends StatefulWidget {
  @override
  NewPostFormState createState() {
    return NewPostFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewPostFormState extends State<NewPostForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Title:'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Price:'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: priceController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Description:'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: descController,
              maxLines: 5,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Image(
                image: FileImage(new File(MiscParameters.tempImagePath)),
                height: 150,
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPreviewScreen(),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    print('Title: ' +
                        titleController.text +
                        "\t" +
                        'Price: ' +
                        priceController.text +
                        "\t" +
                        'Desc: ' +
                        descController.text +
                        "\t" +
                        MiscParameters.tempImagePath);
                    PostCollection.add(titleController.text, priceController.text,
                        descController.text, MiscParameters.tempImagePath);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  }
                },
                child: Text('Post'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraPreviewScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Picture Preview')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            MiscParameters.tempImagePath = path;
            print('Image is saved at - ' + path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Center(
          child: Column(
            children: [
              Image.file(File(imagePath)),
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    Navigator.pushNamed(context, '/newpost');
                  })
            ],
          ),
        ));
  }
}
