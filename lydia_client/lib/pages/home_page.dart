import 'package:flutter/material.dart';
import 'package:lydia_client/components/forms/my_button.dart';
import 'package:lydia_client/components/my_snackbar.dart';
import 'package:lydia_client/pages/auth/sign_in.dart';
import 'package:lydia_client/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        body: authProvider.isAuthenticated
            ? SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome, ${authProvider.user!.name}'),
                      const SizedBox(height: 20),
                      const Text('You are now signed in!'),
                      const SizedBox(height: 40),
                      MyButton('Sign Out', onPressed: () {
                        authProvider.signOut();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const MySnackBar("We'll see you next time!"),
                          backgroundColor: Theme.of(context).primaryColor,
                        ));
                      }, icon: Icons.logout),
                    ],
                  ),
                ),
              )
            : const SignInPage(),
      ),
    );
  }
}
