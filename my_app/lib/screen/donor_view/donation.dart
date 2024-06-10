import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr_image.dart';

class DonationSummary extends StatefulWidget {
  final String donationId;

  const DonationSummary({super.key, required this.donationId});

  @override
  State<DonationSummary> createState() => _DonationSumState();
}

class _DonationSumState extends State<DonationSummary> {
  String? _currentStatus;
  String? _newStatus;
  bool _canUpdate = true;

  @override
  void initState() {
    super.initState();
    _currentStatus = '';
    _newStatus = _currentStatus;
    _canUpdate = true;
    _cancelStatus();
  }

  Future<void> _cancelStatus() async {
    final donationProvider = Provider.of<DonationList>(context, listen: false);
    _currentStatus = await donationProvider.cancelStatus(widget.donationId);
    setState(() {
      _newStatus = 'Cancelled';
      _canUpdate = !(_currentStatus == 'Complete' || _currentStatus == 'Cancelled');
    });
  }

  void _showProofDialog(BuildContext context, String? proofUrl) {
    if (proofUrl != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Photo of Donation'),
            content: Image.network(proofUrl),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController QRcontroller = TextEditingController();
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
            return ListView(
              children: [Padding(
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
                  Text('For Delivery: ${donationData['Mode of Delivery']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Date: ${donationData['Date']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Address: ${donationData['Address']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Contact Number: ${donationData['Contact Number']}', style: TextStyle(fontFamily: 'Roboto')),
                  Text('Weight: ${donationData['Weight']}', style: TextStyle(fontFamily: 'Roboto')),
                  SizedBox(height: 20.0),
                  if (donationData['photoOfdonation'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Photo of Donation:', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => _showProofDialog(context, donationData['photoOfdonation']),
                          child: Image.network(
                            donationData['photoOfdonation'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                  if (donationData['photoOfproof'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Photo of Proof:', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => _showProofDialog(context, donationData['photoOfproof']),
                          child: Image.network(
                            donationData['photoOfproof'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: (_canUpdate && _newStatus != null)
                        ? () async {
                            // Update donation status
                            await donationProvider.updateDonationStatus(widget.donationId, _newStatus!);
                            Navigator.pop(context, _newStatus); // Return new status to previous screen
                          }
                        : null,
                    child: Text('Cancel Donation'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return QRImage('${donationData['id']}');
                            }),
                          ),
                        );
                      },
                      child: const Text('GENERATE QR CODE'),
                    ),
                  ),
                ],
              ),
            )]);
          }
        },
      ),
    );
  }
}
