import 'package:flutter/material.dart';
import '../donor.dart';
import '../homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    initialRoute: '/main',
    routes: {
      '/main': (context) => const Homepage(),
      '/donationPage': (context) => const DonationPage()
  //    '/profile': (context) => const ProfilePage()
    },
    onGenerateRoute: (settings) {
    if (settings.name == DonationPage.routename) {
    return MaterialPageRoute(
          builder: (context) => const Scaffold(
             body: DonationPage(),
          ),
        );
  }
},
  );
  }
}
