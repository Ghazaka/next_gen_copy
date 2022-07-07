// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  static const routeName = '/password-reset';

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _form = GlobalKey<FormState>();
  final userEmailController = TextEditingController();

  late String _userEmail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Lupa Kata Sandi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Ubah kata Sandi',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Silahkan masukan email Anda untuk\nmembuat kata sandi baru.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Your Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'The value must not be null';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            userEmailController.text.isEmpty
                                ? Colors.grey
                                : Colors.red[700],
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                        onPressed: () {
                          if (!_form.currentState!.validate()) {
                            return;
                          }
                          _form.currentState!.save();
                          Provider.of<Auth>(context, listen: false)
                              .resetPassword(_userEmail)
                              .catchError((e) {
                          });
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
