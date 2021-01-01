import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Number Trivia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = new TextEditingController();
  Widget responseReceived;
  void initState() {
    responseReceived = Container(
      child: Text('The result will be displayed here!'),
    );
  }

  Future<String> _getTrivia(String number) async {
    String result;
    final response = await http.get('http://numbersapi.com/${number}');
    return response.body;
  }

  _buttonClicked(String number) {
    setState(() {
      responseReceived = FutureBuilder(
          future: _getTrivia(number),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return Text(snapshot.data);
            } else {
              return Text('There was an error');
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          FlatButton(
            child: Text('Get Trivia'),
            onPressed: () {
              print('Button Pressed');
              if (_controller.text.length > 0) {
                _buttonClicked(_controller.text);
              } else {
                setState(() {
                  responseReceived =
                      Text('Please enter some number in the text field.');
                });
              }
            },
          ),
          responseReceived,
        ],
      ),
    );
  }
}
