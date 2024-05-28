import 'package:cmsc23proj/screen/donor_view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../model/donor_model.dart';
import 'donor_view/qr_image.dart';



class DonationSum extends StatelessWidget {
  static const routename = '/Donation';
  final Donation donationentry;
  const DonationSum({super.key, required this.donationentry});

  @override
  Widget build(BuildContext context) {

    TextEditingController QRcontroller = TextEditingController();

    return Scaffold(  
      body: Center(
      child: Column(
      children: [
          const Icon(Icons.person),
          Text('DONATION FOR ${donationentry.orgName}',
          style: const TextStyle(fontSize: 20.0, 
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,),
            Row(
          children: [const Expanded(
          child: Text('Will donate food?',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.checkFood? "Yes" : "No",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Will donate clothes?',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.checkClothes? "Yes" : "No",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Will donate cash?',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.checkCash? "Yes" : "No",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Will donate necessities?',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.checkNecessities? "Yes" : "No",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Logistics: ',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.checkLogistics? "Pick-Up" : "Delivery",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Total Weight of Donations',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.weight,
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Date and Time for pickup/dropoff',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.date,
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Visibility(
          visible: donationentry.checkLogistics,
          child: Column(
            children: [
        Row(
        children: [const Expanded(
          child: Text('Pickup Address',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.address ?? "N/A",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('Contact Number',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(donationentry.contactNo ?? "N/A",
          style: const TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),
        
        Padding(
          padding: const EdgeInsets.all(50),
          child: TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return QRImage(QRcontroller);
                    }),
                  ),
                );
              },
              child: const Text('GENERATE QR CODE')),)])),

        Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
                onPressed: () {
              Navigator.pop(context, Homepage);
          },
                  child: const Text('Back',
                              style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
        
          ));
  }
  }