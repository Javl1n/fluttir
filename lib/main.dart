import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'listofusers.dart';

void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(Registration());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class Registration extends StatelessWidget{
  const Registration({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(

      home: RegistrationHome(),
    );
  }
}
class RegistrationHome extends StatefulWidget{
  const RegistrationHome({super.key});

  @override
  State<RegistrationHome> createState() => _RegistrationHomeState();
}

class _RegistrationHomeState extends State<RegistrationHome> {
  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                        ),
                        TextField(
                          controller: fullNameController,
                        ),
                        TextField(
                          controller: usernameController,
                        ),
                        TextField(
                          controller: passwordController,
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              var apiUrl = '${globals.api_url}/registration.php';

                              if(emailController.text.isEmpty){
                                print("Email is empty");
                              }
                              else if(fullNameController.text.isEmpty){
                                print("Fullname is empty");
                              }
                              else if(usernameController.text.isEmpty){
                                print("Username is EMpty");
                              }
                              else if(passwordController.text.isEmpty){
                                print("Password is Empty");
                              }
                              else{
                                var email = emailController.text;
                                var fullname = fullNameController.text;
                                var username = usernameController.text;
                                var password = passwordController.text;
                                var res = await
                                http.post
                                  (
                                    Uri.parse(apiUrl),
                                    headers: {
                                      "Accept" : "application/json",
                                      "Access-Controll-Allow_Origin": "*"
                                    },
                                    body: {
                                      'email' : email,
                                      'fullname': fullname,
                                      'username' : username,
                                      'password' : password
                                    }

                                );
                                if(res.statusCode == 200){
                                  var jsonResponse = json.decode(res.body);
                                  var message = jsonResponse['message'];
                                  print(message);
                                }

                              }
                            },
                            child: const Text('Register')
                        )

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}