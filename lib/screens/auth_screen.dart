// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../errors/http_exception.dart';
import '../providers/auth.dart';
import './password_reset_screen.dart';
import './sign_up_option_screen.dart';
import '../widgets/common_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  bool _isObcure = true;
  final Map _userData = {
    'email': null,
    'password': null,
  };

  void _showErrorDialog(String message) {
    setState(() {
      _isLoading = false;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login failed!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _tryAuthenticate() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(
        context,
        listen: false,
      ).login(
        _userData['email'],
        _userData['password'],
      );
    } on HttpException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.toString().contains('EMAIL_EXIST')) {
        errorMessage = 'This email address is already in use.';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is to weak';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'Could not authenticate please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.97),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selamat datang di\nNextGen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The value must not be null';
                          } else if (value.contains(' ')) {
                            return 'The value must not contains space';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData['email'] = value;
                        },
                        hintText: 'Email',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The value must not be null';
                          } else if (value.contains(' ')) {
                            return 'The value must not contains space';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userData['password'] = value;
                        },
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            !_isObcure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: Colors.black,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _isObcure = !_isObcure;
                            });
                          },
                        ),
                        obscureText: _isObcure,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              PasswordResetScreen.routeName,
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.red[700],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _tryAuthenticate();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.red[700],
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 13),
                                  ),
                                ),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 17,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun?',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pushNamed(
                                SignUpOptionScreen.routeName,
                              );
                            },
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 17,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
