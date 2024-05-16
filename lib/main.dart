import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/donation_provider.dart';
import 'screen/donor.dart';
import 'screen/homepage.dart';
import '../screen/profile.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DonationList()),
  ], child: const MyApp()));
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
      '/donationPage': (context) => const DonationPage(),
      '/profile': (context) => const Profile()
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
