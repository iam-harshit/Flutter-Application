import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/product-show.dart';
import 'package:ecommerce_app/productDataModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application',
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
      ),
      home: const MyHomePage(title: 'Flutter Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
      body: FutureBuilder(
        future: readJsonData(),
        builder: (context, data){
          if(data.hasError){
            return Center(child: Text("${data.error}"));
          }else if(data.hasData){
            var items = data.data as List<productDataModel>;
            return Center(
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {

                  for (var i = 0; i < items.length; i++) {
                    Map<String, dynamic> data =
                    {"productName":items[i].productName.toString(),
                      "productUrl":items[i].productUrl.toString(),
                      "productRating":items[i].productRating.toString(),
                      "productDescription":items[i].productDescription.toString()
                    } as Map<String, dynamic>;
                    FirebaseFirestore.instance.collection("productData").add(data);
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => productShow()));
                },
                child: Text("Click on me",
                style: TextStyle(
                  fontSize: 17,
                ),
                ),
              ),
            );
          }else{
            return Center(
              child: FadeInImage(
                placeholder: AssetImage("assets/loader/loader.gif"),
                image: AssetImage("assets/loader/loader.gif"),
                width: 70,
                height: 70,
              ),
            );
          }
        },
      )
    );
  }

  Future<List<productDataModel>>readJsonData() async{

  final jsonData = await rootBundle.rootBundle.loadString("assets/json/product-listing.json");
  final list = json.decode(jsonData) as List<dynamic>;
  return list.map((e) => productDataModel.fromJson(e)).toList();
    
  }

}
