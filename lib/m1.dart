import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_export.dart';
import 'package:firebase_core/firebase_core.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAItW9EAXuW7orSd_PU1_dOhCo_glnma5s',
        appId: '1:75024762434:web:98aa5cc0c17c451f320fdb',
        messagingSenderId: '75024762434',
        projectId: 'spenzy-7dc2e',
        storageBucket: 'spenzy-7dc2e.appspot.com',
      )
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'spenzy',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.loginScreen,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}