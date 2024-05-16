import 'package:cmsc23proj/screen/homepage.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../provider/donation_provider.dart';
import '../model/donor_model.dart';
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
                    trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon:
                                              const Icon(Icons.cancel_sharp),
                                          onPressed: () {
                                            context
                                                .read<DonationList>()
                                                .changeSelectedSlambook(
                                                    donationlist[index]);
                                            context
                                                .read<DonationList>()
                                                .removeDonation();
                                          }),
                                    ],
                                  ) 
              );}),
            )],
          ));
  }
}