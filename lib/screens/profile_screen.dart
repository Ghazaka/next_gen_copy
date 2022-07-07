import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.red[700],
            );
          },
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.red[700],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}
