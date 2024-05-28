import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import '../screen/home_page.dart';
import '../provider/auth_provider.dart';
import '../provider/donation_provider.dart';
import '../screen/donor_view/donor.dart';
import '../screen/donor_view/homepage.dart';
import '../screen/donor_view/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: (context) => DonationList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draft',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/donor_main': (context) => const Homepage(),
        '/donor_donationPage': (context) => const DonationPage(),
        '/donor_profile': (context) => const Profile()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
