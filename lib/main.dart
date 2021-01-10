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
      child: Text(
        'The result will be displayed here!',
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<String> _getTrivia(String number) async {
    String result;
    final response = await http.get('http://numbersapi.com/${number}');
    return response.body;
    // await Future.delayed(Duration(seconds: 1));
    // return '$number is a good number.';
  }

  _buttonClicked(String number) {
    setState(() {
      responseReceived = FutureBuilder(
          future: _getTrivia(number),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data,
                textAlign: TextAlign.center,
              );
            } else {
              return Text(
                'There was an error',
                textAlign: TextAlign.center,
              );
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    errorBorder: InputBorder.none,
                    contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter the number here!"),
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              width: 200,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                padding: const EdgeInsets.all(8.0),
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
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width/1.2,
            child: Card(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: responseReceived),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
