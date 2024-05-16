import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:provider/provider.dart";
import '../provider/organization_provider.dart';
import '../model/donor_model.dart';
import '../model/org_model.dart';
import 'donor.dart';
import 'profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const routename = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

    List<Organization> orgCatalog = [
    Organization(name : "Org 1", about: "Computer Science", status: true),
    Organization(name : "Org 2", about: "Biology", status: true),
    Organization(name : "Org 3", about: "Community", status: true),
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

      /*Widget getItems(BuildContext context) {
    List<Donation> donationlist = context.watch<DonationList>().cart;
    String productname = "";
    return donationlist.isEmpty
        ? Center (child: Column(children: [Text('No Donations yet!'), 
        TextButton(
          child: const Text('Add a donation'),
          onPressed: () async {
          Navigator.pushNamed(context, DonationPage.routename);
          })]))
        : Expanded(
            child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: donationlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                            title: Text(donationlist[index]
                                .date!), //The title of the list tile will only have the friend's name
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonationSum(
                                        donationentry: donationlist[index]),
                    ),
                  );
                },
              );}),
            )],
          ));
  }*/
}
