import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationInfoPage extends StatefulWidget {
  final String donationId;

  DonationInfoPage({required this.donationId});

  @override
  _DonationInfoPageState createState() => _DonationInfoPageState();
}

class _DonationInfoPageState extends State<DonationInfoPage> {
  String? _currentStatus;
  String? _newStatus;
  bool _canUpdate = true;

  @override
  void initState() {
    super.initState();
    _currentStatus = '';
    _newStatus = _currentStatus;
    _canUpdate = true;
    _getStatus();
  }

  Future<void> _getStatus() async {
    final donationProvider = Provider.of<DonationList>(context, listen: false);
    _currentStatus = await donationProvider.getStatus(widget.donationId);
    setState(() {
      _newStatus = _currentStatus;
      _canUpdate = !(_currentStatus == 'Complete' || _currentStatus == 'Cancelled');
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Information'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: donationProvider.getDonationById(widget.donationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Donation not found.'));
          } else {
            final donationData = snapshot.data!.data()! as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Donation ID: ${widget.donationId}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Status: ${donationData['Status']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Cash: ${donationData['Cash']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Clothes: ${donationData['Clothes']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Food: ${donationData['Food']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Necessities: ${donationData['Necessities']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('For Delivery: ${donationData['For Delivery?']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Date: ${donationData['Date']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Address: ${donationData['Address']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Contact Number: ${donationData['Contact Number']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Weight: ${donationData['Weight']}', style: TextStyle(fontFamily: 'Roboto')),
                  SizedBox(height: 20.0),
                  ...['Pending', 'Confirmed', 'Scheduled for Pick-up', 'Complete', 'Cancelled']
                      .map((status) => RadioListTile(
                            title: Text(status),
                            value: status,
                            groupValue: _newStatus,
                            onChanged: _canUpdate
                                ? (value) {
                                    setState(() {
                                      _newStatus = value as String;
                                    });
                                  }
                                : null,
                          ))
                      .toList(),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: (_canUpdate && _newStatus != null)
                        ? () async {
                            // Update donation status
                            await donationProvider.updateDonationStatus(widget.donationId, _newStatus!);
                            Navigator.pop(context, _newStatus); // Return new status to previous screen
                          }
                        : null,
                    child: Text('Update Status'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
