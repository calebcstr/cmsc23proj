import 'package:cmsc23proj/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:provider/provider.dart";
import '../provider/donation_provider.dart';
import '../model/donor_model.dart';
import 'donor.dart';
import 'donation.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});
  static const routename = '/profile';

  @override
  State<Profile> createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  Donation? donation;
  bool willDonate = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
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
                  onTap: () {
                  Navigator.pop(context);
                }),
              ListTile(
                title: const Text('Donor Homepage'),
                onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
              ),
            ],
          ),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children:[getItems(context)]));
  }

    Widget getItems(BuildContext context) {
    List<Donation> donationlist = context.watch<DonationList>().cart;
    String productname = "";
    return donationlist.isEmpty
        ? Center (child: Column(children: [Text('No Donations yet!'), 
        TextButton(
          child: const Text('Add a donation'),
          onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  })]))
        : Expanded(
            child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: donationlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.card_giftcard),
                            title: Text(donationlist[index]
                                .orgName!), //The title of the list tile will only have the friend's name
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
  }
}


/*
          //If there are no friends added yet, then the program will show that the user does not have any friends yet, if they do, then this text will be hidden
          Center(
              child: Visibility(
                  visible: willDonate,
                  child: const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: Text('You Have No Donations')))),
          Visibility(
              //If they have friends, the program will then show every friend that has been added by the user
              visible: !willDonate,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: donationlist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            //Returns a list tile that can be tapped so that the user will be redirected to the third route which contains the summary of the friend that they have added
                            leading: const Icon(Icons.person),
                            title: Text(donationlist[index]
                                .date!), //The title of the list tile will only have the friend's name
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonationSum(
                                        donationentry: donationlist[index]),
                                  ));
                            });
                      })
                ],
              )),
          //Creates a text button that will navigate the user to the slambook page
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: const Text('Go to Slambook'),
              onPressed: () async {
              /*
                This block of code does:
                  - Navigates user to the slambook page
                  - Makes the program run independently from this function
                  - Basically awaits the results of the given input of the user from the slambook and adds it to the slambookdata list
              */
                final result =
                    await Navigator.pushNamed(context, DonationPage.routename);
                donation = result as Donation?;
                if (donation != null) {
                  //If the slambook is not equal to null, we add the data to the slambookdata list
                  setState(() {
                    donationlist.add(donation!);
                    willDonate = false;
                  });
                }
              }),
        )]*/