import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_drive_provider.dart';
import '../../model/donation_drive_model.dart';

class DonationDrivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donationDriveProvider = Provider.of<DonationDriveProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drives'),
      ),
      body: StreamBuilder(
        stream: donationDriveProvider.drivesStream,
        builder: (context, AsyncSnapshot<List<DonationDrive>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Log the error and display it in the UI
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else {
            final drives = snapshot.data!;

            return ListView.builder(
              itemCount: drives.length,
              itemBuilder: (context, index) {
                final drive = drives[index];
                return ListTile(
                  title: Text(drive.name),
                  subtitle: Text(drive.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      donationDriveProvider.deleteDonationDrive(drive.donationDriveId);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_donation_drive');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
