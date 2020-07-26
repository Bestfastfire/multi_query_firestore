import 'package:multi_query_firestore/multi_query_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _fs = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: MultiQueryFirestore(
            list: [
                _fs.collection('users').where('age', isLessThan: 10),
                _fs.collection('users').where('age', isGreaterThan: 20),
                _fs.collection('people').where('height', isGreaterThan: 172)
            ]
        ).snapshots(),
        builder: (c, s){
          if(s.connectionState != ConnectionState.done){
            return Center(
              child: CircularProgressIndicator()
            );
          }

          final list = s.data.documents;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(list[i].data['name'])
            )
          );
        },
      ),
    );
  }
}
