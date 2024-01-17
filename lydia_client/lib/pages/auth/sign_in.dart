import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lydia_client/components/forms/my_button.dart';
import 'package:lydia_client/components/forms/my_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:lydia_client/components/typography/my_explanation.dart';
import 'package:lydia_client/components/typography/my_h1.dart';
import 'package:lydia_client/pages/auth/access_code.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    var currentContext = context;

    Future signIn() async {
      var url = Uri.parse('http://localhost:1337/session/new');
      await http.post(url,
          body: json.encode({'email': emailController.text}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyH1('Tulsa Gold & Gems'),
              const SizedBox(height: 20),
              const MyExplanation('Welcome! Please sign in below.'),
              const SizedBox(height: 40),
              MyTextField('Email', controller: emailController),
              const SizedBox(height: 20),
              MyButton('Sign In', onPressed: () {
                signIn();
                Navigator.of(currentContext).push(MaterialPageRoute(
                    builder: (context) =>
                        AccessCodePage(emailController.text)));
              }, icon: Icons.login),
            ],
          ),
        ),
      ),
    );
  }
}
