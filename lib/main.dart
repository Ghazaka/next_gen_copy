import 'package:flutter/material.dart';
import 'package:next_gen_copy/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './providers/auth.dart';
import './providers/user.dart';
import './screens/notification_screen.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/password_reset_screen.dart';
import './screens/sign_up_option_screen.dart';
import './screens/profile_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, User>(
          create: (_) => User(),
          update: (_, authData, userData) {
            if (authData.token == null) {
              return userData!;
            }
            return userData!
              ..getAuthData(
                authData.userId!,
                authData.token!,
              );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyHome(),
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomRoute(),
            }
          ),
        ),
        routes: {
          NotificationScreen.routeName: (_) => const NotificationScreen(),
          PasswordResetScreen.routeName: (_) => const PasswordResetScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
          SignUpOptionScreen.routeName: (_) => const SignUpOptionScreen(),
          SignUpScreen.routeName: (_) => const SignUpScreen()
        },
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);

    return authData.isAuth
            ? const HomeScreen()
            : FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (ctx, authSnapshotData) =>
                    authSnapshotData.connectionState == ConnectionState.waiting
                        ? const Scaffold(
                            body: CircularProgressIndicator(),
                          )
                        : const AuthScreen(),
              );
  }
}
