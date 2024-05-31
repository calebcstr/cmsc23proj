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
import '../provider/donation_drive_provider.dart';
import '../screen/org_view/add_donation_drive.dart';
import '../provider/organization_provider.dart';

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
        ChangeNotifierProvider(create: ((context) => DonationDriveProvider())),
        ChangeNotifierProvider(create: (_) => OrganizationIdProvider()),
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
        '/donor_profile': (context) => const Profile(),
          '/add_donation_drive': (context) => const AddDonationDrivePage(), // Add the new route here
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
