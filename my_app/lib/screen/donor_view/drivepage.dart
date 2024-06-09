import 'package:cmsc23proj/screen/donor_view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_drive_provider.dart';
import '../../model/donation_drive_model.dart';
import '../../provider/auth_provider.dart';
import 'donor.dart';

class DonationDrivePage extends StatefulWidget {
  final String? orgId;
  const DonationDrivePage({super.key, this.orgId});
  static const routename = '/drivepage';

  @override
  State<DonationDrivePage> createState() => _DonationDrivePageState();
}

class _DonationDrivePageState extends State<DonationDrivePage> {

  @override
  Widget build(BuildContext context) {
    if (widget.orgId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Donation Drive'),
        ),
        body: const Center(child: Text('Organization ID is missing.')),
      );
    }

    Stream<List<DonationDrive>> driveStream = 
      context.watch<DonationDriveProvider>().getDrivesbyOrgId(widget.orgId!);
    final userProvider = Provider.of<UserAuthProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Drive'),
      ),
      /*drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Profile Page'),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
              ),
              ListTile(
                title: const Text('Donor Homepage'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  await context.read<UserAuthProvider>().signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),*/
      body: StreamBuilder<List<DonationDrive>>(
        stream: driveStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
              children: [
            Text("No Donation Drives Found"),
            TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ),
                    );
                  },
                  child: const Text("Back"),
                )]));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var drive = snapshot.data![index];
                      return ListTile(
                        title: Text(drive.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationPage(orgID: drive.organizationId, driveID: drive.donationDriveId, email: user!.email),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
