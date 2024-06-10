import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File? _proofImage;
  String? proofImageURL;
  String? errorMessage;
  bool isLoading = false;

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

  Future<void> _choosePhotoProof() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _proofImage = imageFile;
      });

      // Upload image to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('proof_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          proofImageURL = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
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
    final donationProvider = Provider.of<DonationList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Information'),
      ),
      body: ListView(
        children: [StreamBuilder<DocumentSnapshot>(
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
                  if (_newStatus == 'Complete' && proofImageURL == null)
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _choosePhotoProof,
                          child: Text('Upload Proof of Legitimacy'),
                        ),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        if (_proofImage != null)
                          InkWell(
                            onTap: () => _showProofDialog(context, proofImageURL!),
                            child: Text(
                              'View Photo Proof',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
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
                    onPressed: (_canUpdate && _newStatus != null && (_newStatus != 'Complete' || (proofImageURL != null)))
                        ? () async {
                            if (_newStatus == 'Complete' && proofImageURL == null) {
                              setState(() {
                                errorMessage = 'Please upload proof of legitimacy.';
                              });
                            } else if (_newStatus == 'Complete' && proofImageURL != null) {
                              // Update donation status
                              await donationProvider.completeDonationStatus(widget.donationId, _newStatus!, proofImageURL!);
                              Navigator.pop(context, _newStatus); // Return new status to previous screen
                            } else if (_newStatus != 'Complete' && proofImageURL == null) {
                              // Update donation status
                              await donationProvider.updateDonationStatus(widget.donationId, _newStatus!);
                              Navigator.pop(context, _newStatus); // Return new status to previous screen
                            }
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
    ]));
  }
}
