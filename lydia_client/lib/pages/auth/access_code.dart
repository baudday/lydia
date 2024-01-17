import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lydia_client/components/forms/my_button.dart';

import 'package:lydia_client/components/forms/my_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:lydia_client/components/my_snackbar.dart';
import 'package:lydia_client/components/typography/my_explanation.dart';
import 'package:lydia_client/components/typography/my_h1.dart';
import 'package:lydia_client/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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

    Future<String?> authenticate() async {
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
        return jsonDecode(response.body)['token'];
      }

      return null;
    }

    setAccessCode(k, String value) {
      value = value.toUpperCase();

      if (value.length < 2) {
        accessCode[k].text = value;
      } else {
        for (var i = k; i < value.length && i < 6; i++) {
          accessCode[i].text = value.split('')[i];
        }
      }
    }

    shiftFocusFrom(k) => (value) {
          if (value.length == 1 && k < accessCode.length) {
            FocusScope.of(context).nextFocus();
          } else if (value.length == 0 && k > 0) {
            FocusScope.of(context).previousFocus();
          }
        };

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 200),
                const MyH1('Tulsa Gold & Gems'),
                const SizedBox(height: 20),
                const MyExplanation(
                    'You should have received an email with a 6-digit access code. Please enter it below. If you did not receive an email, you can go back and try requesting one again. If you are still having trouble, please contact us.'),
                const SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: accessCode
                        .asMap()
                        .keys
                        .map((k) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                width: 100,
                                child: MyTextField(
                                  '',
                                  controller: accessCode[k],
                                  onChanged: (value) {
                                    setAccessCode(k, value);

                                    if (accessCode
                                            .where((element) =>
                                                element.text.isNotEmpty)
                                            .length ==
                                        6) {
                                      authenticate().then((token) {
                                        if (token == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const MySnackBar(
                                                'We were unable to authenticate you. Please try again.'),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          ));
                                        } else {
                                          authProvider.signIn(token);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const MySnackBar(
                                                'Authentication successful!'),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          ));
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .clearMaterialBanners();
                                        }
                                      });
                                    } else {
                                      shiftFocusFrom(k)(value);
                                    }
                                  },
                                ),
                              ),
                            ))
                        .toList()),
                const SizedBox(height: 40),
                MyButton('Back',
                    onPressed: () => {Navigator.pop(context)},
                    secondary: true,
                    icon: Icons.arrow_back),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
