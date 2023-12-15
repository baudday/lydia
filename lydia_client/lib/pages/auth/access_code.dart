import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lydia_client/components/forms/my_button.dart';

import 'package:lydia_client/components/forms/my_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:lydia_client/components/typography/my_explanation.dart';
import 'package:lydia_client/components/typography/my_h1.dart';

class AccessCodePage extends StatelessWidget {
  final String email;

  const AccessCodePage(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accessCode = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];

    authenticate() async {
      var url = Uri.parse('http://localhost:1337/session/create');
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'accessCode': accessCode.map((a) => a.text).join('')
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      if (response.statusCode == 200) {
        debugPrint('success');
      } else {
        debugPrint('fail');
      }
    }

    setAccessCode(k, String value) {
      if (value.length < 2) {
        accessCode[k].text = value;
      } else {
        for (var i = k; i < value.length && i < 6; i++) {
          accessCode[i].text = value.split('')[i];
        }
      }
    }

    onChange(k) => (value) async {
          if (value.length == 1 && k < accessCode.length) {
            FocusScope.of(context).nextFocus();
          } else if (value.length == 0 && k > 0) {
            FocusScope.of(context).previousFocus();
          }

          setAccessCode(k, value);
        };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 200),
              const MyH1('Tulsa Gold & Gems'),
              const SizedBox(height: 20),
              const MyExplanation(
                  'You should have received an email with an access code. Please enter it below.'),
              const SizedBox(height: 40),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: accessCode
                      .asMap()
                      .keys
                      .map((k) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: 100,
                              child: MyTextField(
                                '',
                                controller: accessCode[k],
                                onChanged: onChange(k),
                              ),
                            ),
                          ))
                      .toList()),
              const SizedBox(height: 40),
              MyButton(
                'Authenticate',
                icon: Icons.lock,
                onPressed: authenticate,
              ),
              const SizedBox(height: 10),
              MyButton('Back',
                  onPressed: () => {Navigator.pop(context)},
                  secondary: true,
                  icon: Icons.arrow_back),
            ],
          ),
        ),
      ),
    );
  }
}
