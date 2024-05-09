import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../donor.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const routename = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
  //list of organizations
}

class _HomepageState extends State<Homepage> {

 Widget build(BuildContext context) {
          return Scaffold(
        appBar: AppBar(
          title: const Text('Homepage'),
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
                    title: const Text('Donation Box'),
                    onTap: () async {Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const DonationPage()));}),
                ListTile(
                  title: const Text('Homepage'),
                  onTap: () {
                    Navigator.pop(context);
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                  },
                ),
              ],
            ),
          ),
        ),

        body: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(child: Text("Display List of Organizations", 
                overflow: TextOverflow.ellipsis,
                 style: TextStyle(color: Colors.black,
                    fontSize: 24.0)
                 ))
          
        ]));
 }
 
}