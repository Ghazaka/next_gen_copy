import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './notification_screen.dart';
import '../providers/user.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.red[700],
            indicatorWeight: 2.5,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
            tabs: const <Widget>[
              Tab(
                // text: 'Categories',
                child: Text(
                  'Semua',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'STEMPeneur Day',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'STEMPeneur Fair',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'STEMPeneur',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
            iconSize: 28,
            color: Colors.red[700],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'NextGen',
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.w700,
              fontSize: 23
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NotificationScreen.routeName);
              },
              icon: const Icon(Icons.notifications_none),
              color: Colors.red[700],
              iconSize: 28,
            )
          ],
        ),
        body: const TabBarView(
          children: [
            HomeBody(),
            HomeBody(),
            HomeBody(),
            HomeBody(),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Provider.of<Auth>(context, listen: false).logout();
          Navigator.of(context).pushReplacementNamed('/');
        },
        child: const Text('Logout'),
      ),
    );
  }
}
