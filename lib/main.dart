import 'package:flutter/material.dart';
import 'package:myapi/Model/databaseClient.dart';
import 'package:myapi/Model/ip.dart';
import 'package:myapi/Article.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MyApi'),
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
 
// Déclaration de la liste de données ip initialement null
  String nouvelleListe;
  String ipservers;
   // Déclaration de la liste de données ip initialement
  List<Ip>ips = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }
   void recuperer(){
   DatabaseClient().oneIp().then((ips) {
     setState(() {
      this.ips = ips;
      print(ips.length);
     });
   });
 }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
          actions:  <Widget>[
           FlatButton(
            onPressed: (){
              ipServer();
            },
            child: new Text("Ajouter une adresse ip", style: TextStyle(color:Colors.white),) ,
          )
        ] ,
      ),
      body: (ips == null || ips.length == 0)
          ?  Center(
        child: Text('Aucune Addresse ip configurée',
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontStyle: FontStyle.italic
        ),
        ),
      ) : new ListView.builder(itemCount: ips.length,
            itemBuilder: (context, int i) {
              Ip ip = ips[i];
              return new ListTile(
                title: new Text(ip.adresseIp ?? ''),
                );
            }
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){versArticle();},
        tooltip: 'Article',
        child: Icon(Icons.settings_remote),
      ),
    );
  }

  // Mes Fonctions


    Future ipServer() async{
     return showDialog(context: context,
     barrierDismissible: false,
     builder: (BuildContext context){
       return AlertDialog(
         // Ajustement à faire en fonction des écrans (Ecran S8)
         //title: Text('CONFIGURATION IP SERVER',textScaleFactor: 0.9,),
         title: Text('CONFIGURATION IP SERVER',textScaleFactor: 1.0,),
         content: new TextField(
           decoration: InputDecoration(
             labelText: 'IP SERVER',
             // placeholder 
             hintText: "http://192.168.1.1"
           ),
           onChanged: (String str){
            nouvelleListe = str;
           },
         ),
         contentPadding: EdgeInsets.all(5.0),
         actions: <Widget>[
           new FlatButton(
             onPressed: (){
                Navigator.pop(context);
             },
             child: Text('ANNULER',style: TextStyle(color: Colors.red,fontWeight:FontWeight.bold),),
           ),
           new FlatButton(
             onPressed: (){
               if(nouvelleListe != null){
                 Map<String, dynamic> map = {'adresseIp': nouvelleListe};
               Ip ip = new Ip();
               ip.fromMap(map);
               DatabaseClient().ajoutIp(ip).then((i) => recuperer());
               //print(nouvelleListe);
               nouvelleListe = null;
                 Navigator.pop(context);
               }
              // Navigator.pushNamed(context, '/IpList');
             },
             child: Text('ENREGISTRER',style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold),),
           )
         ],
       );
     }
    );
   }

void versArticle(){
  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
    return new Article(title: 'Article');
  }));
}

}
