import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async{
  runApp(MyApp());
 
  final FirebaseApp app = await FirebaseApp.configure(
 
    name: 'Teste',
    options: new FirebaseOptions(
      googleAppID: '1:827208904688:android:1d69dad593e1932377f735',
      gcmSenderID: '827208904688',
      apiKey: 'AIzaSyCBlQNXvspJmx_cd8PaeIfmr20CkOPHXqQ',
      projectID: 'projeto-85013',
      storageBucket: 'projeto-85013.appspot.com',
      clientID: '827208904688-a7jbh71ik9ogc5k6qn426v680gefqkmc.apps.googleusercontent.com',
      bundleID: 'com.example.projetc_firebase',
    ),
  );

  var firestore = new Firestore(app: app);
  firestore.settings(
    persistenceEnabled: true,
    //timestampsInSnapshotsEnabled: true,

  );
 
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cadastro de Usuário'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

 CollectionReference userRef = Firestore.instance.collection('Users').reference();
  String idGravado = "";
class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {

    var novoUsuario = {
      "nome" : "Joao",
      "sobrenome" : "Santos",
      "endereco" : "Rua Bom Jesus",
      "numero" : "163",
      "telefone" : {
        "principal" : "33230112",
        "secundario" : "995391949"
      },
    };

    userRef.add(novoUsuario).then((val) {
        print(val.documentID);
        setState(() {
          idGravado = val.documentID;
        });
    });
  }

TextEditingController nome = new TextEditingController(text: "");
TextEditingController endereco = new TextEditingController(text: "");
TextEditingController email = new TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            inputField(nome, labelText: "Nome", hintText: "Digite o nome do usário", icone: Icons.person),
            inputField(endereco, labelText: "Endereço", hintText: "Digite o seu endereço", icone: Icons.map),
            inputField(email, labelText: "Email", hintText: "Digite o seu email", icone: Icons.email, tipo: TextInputType.emailAddress),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
 TextEditingController texto = new TextEditingController(text: "");


Widget inputField(TextEditingController text, {String hintText = "", String labelText = "", IconData icone = Icons.person, TextInputType tipo = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
    controller: text,
    keyboardType: TextInputType.text,
    autovalidate: true,
    autocorrect: true,
    validator: (val){
      print(val);
      if (val.length < 3) {
        return "Muito curto";
      } if (labelText == "Email") {
        return validateEmail(val);
      }
    },

    decoration: InputDecoration(
    hintText: hintText,
    icon: Icon(icone),
    labelText: labelText,
    ),

    ),
  );
}

String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Digite um e-mail válido';
    else
      return null;
  }


}
