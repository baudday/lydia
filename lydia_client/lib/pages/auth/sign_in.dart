import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lydia_client/components/forms/my_button.dart';
import 'package:lydia_client/components/forms/my_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:lydia_client/components/my_snackbar.dart';
import 'package:lydia_client/components/typography/my_explanation.dart';
import 'package:lydia_client/components/typography/my_h1.dart';
import 'package:lydia_client/pages/auth/access_code.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    Future<dynamic> signIn() async {
      var url =
          Uri.parse('${const String.fromEnvironment('API_URL')}/session/new');
      var response = await http.post(url,
          body: json.encode({'email': emailController.text}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      return response.statusCode == 200
          ? jsonDecode(response.body)['accessCode']
          : null;
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
                signIn().then((code) => {
                      if (code != null)
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AccessCodePage(emailController.text))),
                          ScaffoldMessenger.of(context).showMaterialBanner(
                              MaterialBanner(
                                  content: MySnackBar(
                                      'Success! Your access code is ${code.toString().toUpperCase()}. Normally, we would send this to your email.'),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  actions: [
                                TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentMaterialBanner();
                                    },
                                    child: const Text('Dismiss'))
                              ]))
                        }
                      else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const MySnackBar('Please try again.'),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .errorContainer)),
                        }
                    });
              }, icon: Icons.login),
            ],
          ),
        ),
      ),
    );
  }
}
