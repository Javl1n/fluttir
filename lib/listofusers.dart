import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class ListOfUsers extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        home: ListOfUsersHome()
    );
  }
}
class ListOfUsersHome extends StatefulWidget{
  @override
  State<ListOfUsersHome> createState() => _ListOfUsersHomeState();
}

class _ListOfUsersHomeState extends State<ListOfUsersHome> {
  String apiUrl = "${globals.api_url}/get_users.php";
  var users = [];
  void initState(){
    getUsers();
    super.initState();
  }
  void getUsers() async{
    var res = await
    http.post
      (
        Uri.parse(apiUrl),
        headers: {
          "Accept" : "application/json",
          "Access-Controll-Allow_Origin": "*"
        },
        body: {
          'api_token' : '1234',
        }

    );

    if(res.statusCode == 200){
      var jsonResponse = json.decode(res.body);
      setState(() {
        users = jsonResponse['users'];
      });
      print(users.toString());
    }
    else{
      print("Unsuccessfull");
    }
  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child:  Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(users[index]['fullname']),
                        subtitle: Text(users[index]['email']),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}