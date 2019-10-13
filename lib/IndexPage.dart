import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  
    List<dynamic> data;
     String url = "http:/10.0.2.2:80/sterilevita";
     int count = 0;
     String status;
     Icon icone; 

  // Função para obter os dados JSON
  Future<String> getJSONData() async {
      var response = await http.get(
        Uri.encodeFull("http://10.0.2.2:80/sterilevita_api/embalagem?get=ean"),
        headers: {"Accept": "application/json"}
    );

    setState(() {
      // Pega os dados JSON
      data =  json.decode(response.body);
      print(data);
    });

    return "Dados obtidos com sucesso";

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Sterelivita'),
        ),
        body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Row(children: <Widget>[
                  Text('Solicitações em andamento',style: TextStyle(color: Colors.black,fontSize:25,))
                ],)
              ],
            ),
          ),
          Expanded(
              child: _criaListView())
        ],
      ),
    );
  }

Widget _criaListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _criaImagemColuna(data);
      }
    );
}

Widget _criaImagemColuna(dynamic item) => Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          _criaLinha(item)
        ],
      ),
    );

  
  Widget _criaLinha(dynamic item) {
    count = count +1;
    if (_verificaStatus(item) =='em Conferencia'){
      icone = Icon(Icons.check);
    }
    if (_verificaStatus(item) =='em Etiquetagem') {
      icone = Icon(Icons.add_circle);
    }
    if(_verificaStatus(item) =='em teste') {
      icone = Icon(Icons.pause); 
    }

    return ListTile(
        title: 
        Text(
        'Solicitação Numero: '+item[count]['ses_id'],
         style: TextStyle(color: Colors.black)
        ),
        subtitle: 
     
        Text("Status: "+_verificaStatus(item)),
         leading: icone,);
  }

  String _verificaStatus(dynamic item){
      if( item[count]['status'] == '1'){
         return 'em Conferencia';
       }
       else if (item[count]['ses_status'] == '2') {
          return 'em Etiquetagem';
       } else {
         return 'em teste';
       }
  }


 @override
  void initState() {
    super.initState();
    // Chama o método getJSONData() quando a app inicializa
    this.getJSONData();
  }

}
