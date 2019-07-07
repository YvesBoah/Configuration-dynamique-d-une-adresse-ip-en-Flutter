import 'package:flutter/material.dart';
import 'package:myapi/Model/databaseClient.dart';
import 'package:myapi/Model/ip.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Article extends StatefulWidget {
   Article({Key key, this.title}) : super(key: key);
   final String title;
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
    Map data;
    List<Ip>ips = [];
  List Consultation;
  @override
  void initState() {
    super.initState();
     recuperer();
     _afficherFacture();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new ListView.builder(
                               itemCount: Consultation == null ? 0 : Consultation.length,
                              itemBuilder: (BuildContext context, int index) {
                                return new ListTile(
                                  title:  Text(" ${Consultation == null ? '' : 'title :'+ Consultation[index]['title']}",style: TextStyle(fontSize: 15.0),),
                                  );
                              }
                            ),
     );
     }






void recuperer(){
   DatabaseClient().oneIp().then((ips) {
     setState(() => this.ips = ips);
    var serverIp =ips[0].adresseIp ?? '';
   //  print(serverIp);
   });
 }

  Future<List> _afficherFacture() async {
  DatabaseClient().oneIp().then((ips) async {
     setState(() => this.ips = ips);
    var serverIp =ips[0].adresseIp ?? '';
     print(serverIp);
   //https://jsonplaceholder.typicode.com/todos/1

    final response = await http.get(
        "http://$serverIp.typicode.com/todos",
        headers:{
          HttpHeaders.acceptHeader:'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
         });

//------------------------------------------------------------------------
    var dataUser = json.decode(response.body);
    //print(dataUser);

      setState(() {
        Consultation = dataUser;
         print(Consultation);
      });


    });
  }

}