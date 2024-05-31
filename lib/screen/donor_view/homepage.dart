import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../provider/donation_provider.dart';
import '../../provider/auth_provider.dart';
import '../../model/donor_model.dart';
import '../../model/org_model.dart';
import '../signin_page.dart';
import 'donor.dart';
import 'profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key,});
  static const routename = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

    List<Organization> orgCatalog = [
  ]; 
  Donation? donation;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Homepage'),
      ),
      drawer: Drawer(
        //Creates a drawer for the user
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  title: const Text('Profile Page'),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  }),
              ListTile(
                title: const Text('Donor Homepage'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
            //icon: Icon(Icons.logout),
              onTap: () async {
              await context.read<UserAuthProvider>().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (Route<dynamic> route) => false,
              );
            },
          )
            ],
          ),
        ),
      ),
      body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(Icons.volunteer_activism_outlined),
                title: Text(
                    "${orgCatalog[index].name}"),
                trailing: TextButton(
                  child: Text("Donate to ${orgCatalog[index].name}"),
                  onPressed: () {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonationPage(
                                      org: orgCatalog[index].name
                                    ),
                    ),
                  );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${orgCatalog[index].name} added!"),
                      duration: const Duration(seconds: 1, milliseconds: 100),
                    ));
                  },
                ),
              );
            },
            itemCount: orgCatalog.length),
    );
  }

}
