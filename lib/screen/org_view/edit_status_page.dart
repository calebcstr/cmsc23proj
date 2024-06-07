import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart'; // Import your provider or service

class EditStatusPage extends StatefulWidget {
  final String donationId;

  EditStatusPage({required this.donationId});

  @override
  _EditStatusPageState createState() => _EditStatusPageState();
}

class _EditStatusPageState extends State<EditStatusPage> {
  late String _currentStatus;
  late String _newStatus;
  late bool _canUpdate;

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
        title: Text('Edit Donation Status'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Radio buttons for status options
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
              onPressed: _canUpdate
                  ? () async {
                      // Update donation status
                      await donationProvider.updateDonationStatus(widget.donationId, _newStatus);
                      Navigator.pop(context, _newStatus); // Return new status to previous screen
                    }
                  : null,
              child: Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }
}


