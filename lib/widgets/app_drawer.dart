import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/auth.dart';
import '../screens/profile_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context, listen: false);

    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ProfileScreen.routeName);
              },
              contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              style: ListTileStyle.drawer,
              leading: CircleAvatar(
                radius: 28,
                // maxRadius: 100,
                child: Image.asset(
                  'assets/images/user.png',
                  width: double.infinity,
                ),
              ),
              title: Text(
                userData.items['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text('Lihat Profile'),
            ),
          ),
          const Divider(thickness: 1, height: 0),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 15, top: 3, bottom: 3),
            onTap: () {
              Navigator.of(context).pop();
            },
            title: const Text(
              'Beranda',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 0),
          const ListTile(
            contentPadding: EdgeInsets.only(
              left: 15,
              top: 3,
              bottom: 3,
            ),
            title: Text(
              'Riwayat Acara',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 1),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 15, top: 3, bottom: 3),
            title: Text(
              'Survey',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 0),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 15, top: 3, bottom: 3),
            title: Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 0),
          ListTile(
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
            contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            title: const Text(
              'Keluar',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 0),
        ],
      ),
    );
  }
}
