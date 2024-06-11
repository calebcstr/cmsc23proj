import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart';
import '../../provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donation.dart';


class YourDonations extends StatefulWidget {
  const YourDonations({super.key});
  static const routename = '/orgpage';

  @override
  State<YourDonations> createState() => _YourDonationsState();
}

class _YourDonationsState extends State<YourDonations> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserAuthProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
      ),
      body: SafeArea(
        top: true,
        child: Consumer<DonationList>(
          builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: provider.getDonationsbyEmail(user!.email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No donations found.'));
                } else {
                  final donations = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donation = donations[index];
                      return ListTile(
                        title: Text('Donation ID: ${donation.id}'),
                        subtitle: Text('Status: ${donation['Status']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationSummary(donationId: donation.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
