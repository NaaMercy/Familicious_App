import 'package:familicious_app/manager/auth_manager.dart';
import 'package:familicious_app/views/auth/forgot_password_view.dart';
import 'package:familicious_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'create_account_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final AuthManager _authManager = AuthManager();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const FlutterLogo(
              size: 130,
            ),
            const SizedBox(
              height: 35,
            ),
            TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(label: Text('Email')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }

                  if (value.length < 8) {
                    return "Email is invalid";
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(label: Text('Password')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required!";
                  }

                  if (value.length < 8) {
                    return "Password should be 8 characters long";
                  }
                }),
            const SizedBox(height: 25),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordView())),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ))),
            isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        bool isSuccessful = await _authManager.loginUser(
                            email: _emailController.text,
                            password: _passwordController.text);

                        if (isSuccessful) {
                          Fluttertoast.showToast(
                              msg: _authManager.message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()),
                              (route) => false);
                        } else {
                          //error
                          Fluttertoast.showToast(
                              msg: _authManager.message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .background),
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary),
                    )),
            const SizedBox(height: 1),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const CreateAccountView())),
                    child: const Text(
                      'Create Acoount',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ))),
          ],
        ),
      )),
    );
  }
}
