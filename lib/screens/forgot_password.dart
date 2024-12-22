// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/screens/login_screen.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    Future resetPassword() async {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password reset email sent! Check Your Inbox')),
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return LoginScreen();
        }));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
        Navigator.of(context).pop();
      }
    }

    void handleSendEmail() {
      final email = emailController.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an email.')),
        );
        return;
      }

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email.')),
        );
        return;
      }
      resetPassword();
    }

    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Reset Password'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/Images/logoooo.png'),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                customButton(
                    context: context,
                    text: 'Send Email',
                    onPressed: handleSendEmail,
                    height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
