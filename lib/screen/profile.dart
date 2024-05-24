import 'package:cmsc23proj/screen/homepage.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
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

@override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationStream = 
      context.watch<DonationList>().getDonos;

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

      body: StreamBuilder(
          stream: donationStream,
          builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Text("Error encountered! ${snapshot.error}"),
      );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.data?.size == 0) {
      return Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        const Center(
        child: Text("No Donations Found"), 
      ),
        TextButton(
          child: const Text('Donate now!'),
          onPressed: () async {
          Navigator.pushNamed(context, Homepage.routename);
          })]);
    }

    return 
    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data?.docs.length,
      itemBuilder: ((context, index) {
        Donation donation = Donation.fromJson(
            snapshot.data?.docs[index].data() as Map<String, dynamic>);
      return Dismissible(
          key: Key(donation.id.toString()),
          onDismissed: (direction) {
            context.read<DonationList>().deleteDonation(donation.id!);

             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Donation to ${donation.orgName} is cancelled')));
          },
          background: Container(
            color: Colors.red,
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            title: Text(donation.orgName!),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) =>
              DonationSum (donationentry: donation),
              ));
                                  },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<DonationList>().deleteDonation(donation.id!);
                    },
                  icon: const Icon(Icons.delete_outlined),
                )
              ],
            ),
          ),
        );
      }),
    ),
    TextButton(
          child: const Text('Donate now!'),
          onPressed: () async {
          Navigator.pushNamed(context, Homepage.routename);
          })]);
  },
));
  }
  
/*
    Widget getItems(BuildContext context) {
    List<Donation> donationlist = context.watch<DonationList>().getDonos;
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
                                                .deleteDonation(donationlist[id]);
                                          }),
                                    ],
                                  ) 
              );}),
            )],
          ));
  }*/
}