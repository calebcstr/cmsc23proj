import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart'; 
import '../../provider/auth_provider.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donation_information.dart';

class DonationsToOrganizationPage extends StatelessWidget {
  final String organizationId;

  DonationsToOrganizationPage({required this.organizationId});

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationList>(context, listen: false);
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Donations to Organization'),
      ),
      body: SafeArea(
        top: true,
        child: Consumer<DonationList>(
          builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: provider.getDonationsbyOrg(userAuthProvider.organizationId!),
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
                              builder: (context) => DonationInfoPage(donationId: donation.id),
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
