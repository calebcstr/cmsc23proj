import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../../model/donor_model.dart';
import '../../provider/donation_provider.dart';
import '../../provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DonationPage extends StatefulWidget {
  final String? orgID;
  final String? driveID;
  final String? email;
  const DonationPage({super.key, this.orgID, this.driveID, this.email});
  static const routename = '/donationPage';

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {

//initializing constants
  bool save = false;
  bool summary = false;
//GlobalKey of SlamBook
  final _key = GlobalKey<FormState>();

  bool food = false;
  bool clothes = false;
  bool cash = false;
  bool necessities = false;
  bool logistics = false;

  String? _selectedAddress;

//Text Controllers
  final TextEditingController _date = TextEditingController();
  final TextEditingController _others = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
//clears the text state of the inputted TextFormFields
  void clearTextField() {
  _date.clear();
  _others.clear();
  _weight.clear();
}

// Dispose the controller when the widget is disposed
  @override
  void dispose() {
    _date.dispose();
    _others.dispose();
    _weight.dispose(); // Dispose _weight controller
    _number.dispose();
    super.dispose();
  }

// Initalizes states of name, age, and nickname
     @override
  void initState() {
    super.initState();
    _date.addListener(() {
      print("Latest Value: ${_date.text}");
    });
    _others.addListener(() {
      print("Latest Value: ${_others.text}");
    });
    _weight.addListener(() {
      print("Latest Value: ${_weight.text}");
    });
    _number.addListener(() {
      print("Latest Value: ${_number.text}");
    });
    _address.addListener(() {
      print("Latest Value: ${_address.text}");
    });
    final donorProvider = Provider.of<DonorProvider>(context, listen: false);
    donorProvider.fetchDonorDetails(widget.email!);
  }

  Donation? donation;
    void addEntry(BuildContext context) {
      donation = Donation(
        email: widget.email,
        checkFood: food,
        checkClothes: clothes,
        checkCash: cash,
        checkNecessities: necessities,
        checkLogistics: logistics,
        date: _date.text,
        address: _selectedAddress,
        contactNo: _number.text,
        weight: _weight.text,
        status: "Pending",
        organizationId: widget.orgID!,
        driveId: widget.driveID!,
        photoOfdonation: photoURL);
        context.read<DonationList>().addDonation(donation!);
        Navigator.pop(context);
  }

  Widget buildCheckboxRow(String title, String desc, bool newValue, ValueChanged<bool?> onChanged) {
  return CheckboxListTile(
            title: Text(title),
            subtitle: Text(desc),
            value: newValue,
            onChanged: onChanged,
          );
}

    File? _proofImage;
    String? photoURL;
    String? errorMessage;
    bool isLoading = false;

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
            .child('photo_proofs/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask.whenComplete(() {});
        if (snapshot.state == TaskState.success) {
          final imageUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            photoURL = imageUrl;
          });
        } else {
          throw FirebaseException(
            plugin: 'firebase_storage',
            message: 'Upload failed with state: ${snapshot.state}',
          );
        }
      } on FirebaseException catch (e) {
        setState(() {
          errorMessage = 'Error uploading image: ${e.message}';
        });
        print('Error uploading image: ${e.message}');
      } catch (e) {
        setState(() {
          errorMessage = 'Error uploading image: $e';
        });
        print('Error uploading image: $e');
      }
    } else {
      setState(() {
        errorMessage = 'No image selected.';
      });
    }
  }

  void _showPhotoProofDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(imageUrl),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.black)),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Donation Portal'),
      ),     
        body: Consumer<DonorProvider>(
          builder: (context, provider, child) {
          if (provider.name.isEmpty && provider.email.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
        return Form(
       key: _key,
       child: ListView(
              children: [
                Column(
                  children: [
        const Padding(
              padding: EdgeInsets.all(20),
              child:Text(
              'DONATION BOX',
              style: TextStyle(fontSize: 30.0, 
              fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),


        buildCheckboxRow('Food', 'Donate food items', food, (bool? value) {
          setState(() {
            food = value!;
              });
          }),

        buildCheckboxRow('Clothes', 'Donate any used or clothes that you are not using anymore', clothes, (bool? value) {
          setState(() {
            clothes = value!;
              });
          }),

        buildCheckboxRow('Cash', 'Donate amount of cash', cash, (bool? value) {
          setState(() {
            cash = value!;
              });
          }),

        buildCheckboxRow('Necessities', 'Donate any necessities from hygiene kits and medications', necessities, (bool? value) {
          setState(() {
            necessities = value!;
              });
          }),

        Divider(
          height:20
        ),
        Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child:
        Row(
          children: [
          const Expanded(
          child: Text("For Delivery?")),
          Expanded(
          child: Switch(
          value: logistics,
          onChanged: (bool value) {
            setState(() {
              logistics = value;
            });
          },
          )),
          const Expanded(
          child: Text("For Pickup?")),
          ])),
          
          ]),


           // revise         
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Weight (in kgs/lbs)",
              labelText: "Total Weight of Donation",
            ),
            onChanged: (String value) {
              _weight.text = value;
              print(_weight.text);
            },
            controller: _weight,
        )),

        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter date and time for dropoff/pickup",
              labelText: "Date of dropoff",
            ),
            onChanged: (String value) {
              _date.text = value;
              print(_date.text);
            },
            controller: _date,
        )),

        Visibility(
          visible: logistics,
          child: 
          Column (
            children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Contact Number (for pickup)",
              labelText: "Contact Number",
            ),
            onChanged: (String value) {
              _number.text = value;
              print(_number.text);
            },
            controller: _number,
        )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: 
          DropdownButton<String>(
                      value: _selectedAddress,
                      hint: Text('Address'),
                      items: provider.addresses.map<DropdownMenuItem<String>>((address) {
                        return DropdownMenuItem<String>(
                          value: address['address'],
                          child: Text('${address['type']}: ${address['address']}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAddress = newValue;
                        });
                      },
                    )),
])),                  proofField,
                if (photoURL != null)
                  InkWell(
                    onTap: () => _showPhotoProofDialog(photoURL!),
                    child: Text(
                      'View Photo',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                if (errorMessage != null)
                              signUpErrorMessage
                            else
                              Container(),


      Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                     _key.currentState?.save();
                  setState(() {
                    summary = true;
        });
                    }
                  },
                  child: const Text('Review',
                              style: TextStyle(color: Colors.black)),
                ),
              ),

        //Summary (Visibility)
        Visibility(
          visible: summary,
          child: Column (children: [
            const Text('DONATION',
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
          child: Text("${food? "Yes" : "No"}",
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
          child: Text("${clothes? "Yes" : "No"}",
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
          child: Text("${cash? "Yes" : "No"}",
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
          child: Text("${necessities? "Yes" : "No"}",
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
          child: Text("${logistics? "Pick-Up" : "Delivery"}",
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
          child: Text(_weight.text,
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
          child: Text(_date.text,
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

      Visibility(
        visible: logistics,
        child:
      Column(
        children: [
        Row(
        children: [const Expanded(
          child: Text('Pickup Address',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(_selectedAddress ?? "N/A",
          style: TextStyle(fontSize: 15.0,
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
          child: Text(_number.text,
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))])])),

        Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
                onPressed: () {
              addEntry(context);
          },
                  child: const Text('Save',
                              style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
          ),

//Reset Button (ElevatedButton)
        Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
                onPressed:() {
                   setState(() {
                food = false;
                clothes = false;
                cash = false;
                necessities = false;
                logistics = false;
                summary = false;
                clearTextField();
                  });
  },                
                  child: const Text('Clear',
                              style: TextStyle(color: Colors.white)),
                ),
              ),
  ]),
              
              ]),
    
      
      
      );}}));// This trailing comma makes auto-formatting nicer for build methods.
  }

    Widget get proofField => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _choosePhotoProof,
              child: Text(
                'Photo of Donations (Optional)',
                style: TextStyle(
                  color: Colors.black, // Font color of the button text
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Custom border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 20), // Custom padding
                minimumSize: Size(350, 0), // Minimum button width
              ),
            ),
          ],
        ),
      );

  Widget get signUpErrorMessage => Text(
        errorMessage ?? "",
        style: const TextStyle(color: Colors.red),
      );
}
