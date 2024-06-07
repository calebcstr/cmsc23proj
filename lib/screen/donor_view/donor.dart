import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import "package:provider/provider.dart";
import '../../model/donor_model.dart';
import '../../provider/donation_provider.dart';
import 'qr_image.dart';
import 'profile.dart';

class DonationPage extends StatefulWidget {
  final String? org;
  const DonationPage({super.key, this.org});
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
  }

  Donation? donation;
    void addEntry(BuildContext context) {
      donation = Donation(
        orgName: widget.org, 
        checkFood: food,
        checkClothes: clothes,
        checkCash: cash,
        checkNecessities: necessities,
        checkLogistics: logistics,
        date: _date.text,
        address: _address.text,
        contactNo: _number.text,
        weight: _weight.text,
        status: "Pending",
        organizationId: 'get it from the donation drive'); //GET IT FROM DONO DRIVE
        context.read<DonationList>().addDonation(donation!);
        Navigator.pop(context);
  }

  Widget buildCheckboxRow(String title, String desc, bool newValue, ValueChanged<bool?> onChanged) {
  return CheckboxListTile(
            title: Text(title),
            subtitle: Text(desc),
            value: newValue,
            onChanged: (bool? value) {
              setState(() {
                newValue = value!;
              });
            }
          );
}

Widget buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
  return Column(
    children: [
      Center(
        child: Text(title, overflow: TextOverflow.ellipsis),
      ),
      Center(
        child: Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

  String? _validateOther(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter other items to donate';
    }
    
    return null;
  }


  @override
  Widget build(BuildContext context) {
//entire slambook widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Portal'),
      ),
      drawer: Drawer( //Creates a drawer for the user
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  title: const Text('Profile Page'),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  }),
              ListTile(
                title: const Text('Donation Box'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Homepage'),
                onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
              ),
            ],
          ),
        ),
      ),       
        body: 
        Form(
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


        buildCheckboxRow('Food', 'Donate food items', food, (bool? cash) {
          }),

        buildCheckboxRow('Clothes', 'Donate any used or clothes that you are not using anymore', clothes, (bool? value) {
          }),

        buildCheckboxRow('Cash', 'Donate amount of cash', cash, (bool? cash) {
          }),

        buildCheckboxRow('Necessities', 'Donate any necessities from hygiene kits and medications', necessities, (bool? value) {
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
            //validator: _validateName
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
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Address (for pickup)",
              labelText: "Pickup Address",
            ),
            onChanged: (String value) {
              _address.text = value;
              print(_address.text);
            },
            controller: _address,
        )),
])),


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
            Text('DONATION FOR ${widget.org!}',
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
          child: Text("${food? "Yex" : "No"}",
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
          child: Text("${clothes? "Yex" : "No"}",
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
          child: Text("${cash? "Yex" : "No"}",
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
          child: Text("${necessities? "Yex" : "No"}",
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
          child: Text(_address.text,
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
          child: Text(_address.text,
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
    
      
      
      ));// This trailing comma makes auto-formatting nicer for build methods.
  }
}
