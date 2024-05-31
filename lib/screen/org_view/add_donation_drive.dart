import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/donation_drive_provider.dart';
import '../../provider/organization_provider.dart';
import '../../model/donation_drive_model.dart';

class AddDonationDrivePage extends StatefulWidget {
  const AddDonationDrivePage({Key? key}) : super(key: key);

  @override
  _AddDonationDrivePageState createState() => _AddDonationDrivePageState();
}

class _AddDonationDrivePageState extends State<AddDonationDrivePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donation Drive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final donationDriveProvider =
                        Provider.of<DonationDriveProvider>(context, listen: false);
                    final organizationProvider =
                        Provider.of<OrganizationIdProvider>(context, listen: false);

                    final drive = DonationDrive(
                      donationDriveId: Uuid().v4(), // Generate UUID
                      name: _nameController.text,
                      description: _descriptionController.text,
                      organizationId: organizationProvider.organizationId, // Get the organization ID
                    );
                    donationDriveProvider.addDonationDrive(drive);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Donation Drive'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
