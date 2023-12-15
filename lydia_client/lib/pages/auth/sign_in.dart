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

    signIn() async {
      var url = Uri.parse('http://localhost:1337/session/new');
      await http.post(url,
          body: json.encode({'email': emailController.text}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      // go to access code page
      Navigator.push(
          currentContext,
          MaterialPageRoute(
              builder: (c) => AccessCodePage(emailController.text)));
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
              MyTextField('Email',
                  controller: emailController,
                  onChanged: (value) => {emailController.text = value}),
              const SizedBox(height: 20),
              MyButton('Sign In', onPressed: signIn, icon: Icons.login),
            ],
          ),
        ),
      ),
    );
  }
}
