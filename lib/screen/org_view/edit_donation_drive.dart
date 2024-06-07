import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_drive_provider.dart';

class EditDonationDrivePage extends StatefulWidget {
  final String donationDriveId;
  final String currentName;
  final String currentDescription;

  const EditDonationDrivePage({
    Key? key,
    required this.donationDriveId,
    required this.currentName,
    required this.currentDescription,
  }) : super(key: key);

  @override
  _EditDonationDrivePageState createState() => _EditDonationDrivePageState();
}

class _EditDonationDrivePageState extends State<EditDonationDrivePage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _descriptionController = TextEditingController(text: widget.currentDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateDonationDrive(DonationDriveProvider provider) async {
    await provider.editDonationDrive(widget.donationDriveId, _nameController.text, _descriptionController.text);
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Donation Drive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            Consumer<DonationDriveProvider>(
              builder: (context, provider, _) => ElevatedButton(
                onPressed: () => _updateDonationDrive(provider),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
