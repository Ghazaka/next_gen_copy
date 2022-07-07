// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../providers/user.dart';
import '../errors/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/common_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  bool _isObcure = true;
  final Map _userData = {
    'name': null,
    'birthday': null,
    'school': null,
    'schoolYear': null,
    'field': null,
    'email': null,
    'password': null,
    'phoneNumber': null,
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
      print('Invalid!');
      return;
    }
    FocusScope.of(context).unfocus();
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final signUpData = ModalRoute.of(context)!.settings.arguments as Map;
      final authData = Provider.of<Auth>(context, listen: false);
      await authData.signup(
        _userData['email'],
        _userData['password'],
      );
      for (final item in signUpData.entries) {
        if (item.key == 'identify') {
          _userData.putIfAbsent(item.key, () => item.value);
        }
      }
      http
          .post(
        Uri.parse(
          'https://next-gen-copy-84830-default-rtdb.firebaseio.com/${authData.userId}.json?auth=${authData.token}',
        ),
        body: json.encode(_userData),
      )
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('/');
      });
    } on HttpException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.toString().contains('EMAIL_EXIST')) {
        errorMessage = 'This email address is already exist.';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is to weak';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      // 언제나 외톨이 맘의 문을 닫고
      const errorMessage = 'Could not authenticate please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final signUpData = ModalRoute.of(context)!.settings.arguments as Map;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.97),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.red[700],
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Registrasi ${signUpData['identify']}',
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CommonTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The value must not be null';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userData['name'] = value;
                          },
                          hintText: 'Nama',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1909),
                              lastDate: DateTime.now(),
                            ).then((pickedDate) {
                              if (pickedDate == null) {
                                return;
                              }
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'Tanggal Lahir'
                                  : DateFormat.yMMMd().format(_selectedDate!),
                              style: TextStyle(
                                color: _selectedDate == null
                                    ? Colors.grey[500]
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (signUpData['student'] || signUpData['teacher'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CommonTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'The value must not be null';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userData['school'] = value;
                            },
                            hintText: 'Asal Sekolah',
                          ),
                        ),
                      if (signUpData['teacher'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CommonTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'The value must not be null';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userData['field'] = value;
                            },
                            hintText: 'Bidang Studi',
                          ),
                        ),
                      if (signUpData['student'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CommonTextField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'The value must not be null';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userData['schoolYear'] = value;
                            },
                            hintText: 'Tahun Masuk',
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CommonTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The value must not be null';
                            } else if (value.contains(' ')) {
                              return 'The value must contains space';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userData['email'] = value;
                          },
                          hintText: 'Email',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CommonTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The value must not be null';
                            } else if (value.contains(' ')) {
                              return 'The value must contains space';
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CommonTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The value must not be null';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (int.tryParse(value!) != null) {
                              _userData['phoneNumber'] = int.parse(value);
                            }
                          },
                          hintText: 'No. Handphone',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _tryAuthenticate,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: const Text(
                                  'Buat Akun',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Sudah Punya Akun?',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/');
                            },
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.red,
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
