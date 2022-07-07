import 'package:flutter/material.dart';

import '../extensions/string_extension.dart';
// import './teacher_sign_up_screen.dart';
// import './parent_sign_up_screen.dart';
// import '../screens/student_sign_up_screen.dart';
import '../screens/sign_up_screen.dart';

class SignUpOptionScreen extends StatelessWidget {
  const SignUpOptionScreen({Key? key}) : super(key: key);

  static const routeName = '/sign_up_option';

  @override
  Widget build(BuildContext context) {
    Map signUpData = {
      'identify': null,
      'parent': false,
      'student': false,
      'teacher': false,
    };

    return Scaffold(
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
          'Registrasi',
          style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              'Pendaftaran NextGen',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              'Silahkan daftar dan bergabung dengan rekan\nNextGen lainnya',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2 / 2.3,
              ),
              children: [
                SignUpMethod(
                  name: 'student',
                  tapHandler: () {
                    signUpData = {
                      'identify': 'Siswa',
                      'student': true,
                      'parent': false,
                      'teacher': false,
                    };
                    Navigator.of(context).pushNamed(
                      SignUpScreen.routeName,
                      arguments: signUpData,
                    );
                  },
                ),
                SignUpMethod(
                  name: 'parent',
                  tapHandler: () {
                    signUpData = {
                      'identify': 'Orang Tua',
                      'student': false,
                      'parent': true,
                      'teacher': false,
                    };
                    Navigator.of(context).pushNamed(
                      SignUpScreen.routeName,
                      arguments: signUpData,
                    );
                  },
                ),
                SignUpMethod(
                  name: 'teacher',
                  tapHandler: () {
                    signUpData = {
                      'identify': 'Guru',
                      'student': false,
                      'parent': false,
                      'teacher': true,
                    };
                    Navigator.of(context).pushNamed(
                      SignUpScreen.routeName,
                      arguments: signUpData,
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SignUpMethod extends StatelessWidget {
  const SignUpMethod({
    required this.name,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  final String name;
  final VoidCallback tapHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/$name.png',
              scale: 0.9,
            ),
            Text(
              name.capitalize(),
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
