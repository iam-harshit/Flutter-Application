import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class productShow extends StatefulWidget {
  @override
  _productShowState createState() => _productShowState();
}

class _productShowState extends State<productShow> {

  Widget _buildList(QuerySnapshot snapshot){

    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index){
        final doc = snapshot.docs[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: CachedNetworkImage(placeholder: (context, url) => FadeInImage(placeholder: AssetImage("assets/loader/loader.gif"), image: AssetImage("assets/loader/loader.gif"),),imageUrl: doc["productUrl"], fit: BoxFit.fill,),
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Text(doc["productName"], style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),),
                      Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Text(doc["productDescription"]),),
                      Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Text("Rating: " + doc["productRating"]),),
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("productData").orderBy("productName", descending: false).snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: FadeInImage(
              placeholder: AssetImage("assets/loader/loader.gif"),
              image: AssetImage("assets/loader/loader.gif"),
              width: 70,
              height: 70,
            ),
          );
        }

        return Center(
            child: _buildList(snapshot.requireData),
        );

        },
      ),
    );

  }


}
