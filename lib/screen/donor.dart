import 'package:cmsc23proj/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/donor_model.dart';
import '../provider/donation_provider.dart';
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
  // initializing constants
  bool save = false;
  bool summary = false;

  // GlobalKey of SlamBook
  final _key = GlobalKey<FormState>();

  bool food = false;
  bool clothes = false;
  bool cash = false;
  bool necessities = false;
  bool logistics = false;

  // Text Controllers
  final TextEditingController _date = TextEditingController();
  final TextEditingController _others = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
  TextEditingController QRcontroller = TextEditingController();

  // clears the text state of the inputted TextFormFields
  void clearTextField() {
    _date.clear();
    _others.clear();
    _weight.clear();
    _number.clear();
    _address.clear();
  }

  // Dispose the controller when the widget is disposed
  @override
  void dispose() {
    _date.dispose();
    _others.dispose();
    _weight.dispose(); // Dispose _weight controller
    _number.dispose();
    _address.dispose();
    super.dispose();
  }

  // Initializes states of name, age, and nickname
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
    );
    context.read<DonationList>().addDonation(donation!);
    Navigator.pop(context);
  }

  Widget buildCheckboxRow(String title, String desc, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: Text(desc),
      value: value,
      onChanged: onChanged,
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
    // entire slambook widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Portal'),
      ),
      drawer: Drawer( // Creates a drawer for the user
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
                        builder: (context) => const Profile(),
                      ),
                    );
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
                      builder: (context) => const Homepage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'DONATION BOX',
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                Divider(height: 20),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text("For Delivery?"),
                          ),
                          Expanded(
                            child: Switch(
                              value: logistics,
                              onChanged: (bool value) {
                                setState(() {
                                  logistics = value;
                                });
                              },
                            ),
                          ),
                          const Expanded(
                            child: Text("For Pickup?"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Weight (in kgs/lbs)",
                      labelText: "Total Weight of Donation",
                    ),
                    controller: _weight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter date and time for dropoff/pickup",
                      labelText: "Date of dropoff",
                    ),
                    controller: _date,
                  ),
                ),
                Visibility(
                  visible: logistics,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter Contact Number (for pickup)",
                            labelText: "Contact Number",
                          ),
                          controller: _number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter Address (for pickup)",
                            labelText: "Pickup Address",
                          ),
                          controller: _address,
                        ),
                      ),
                    ],
                  ),
                ),
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
                    child: const Text('Review', style: TextStyle(color: Colors.black)),
                  ),
                ),
                // Summary (Visibility)
                Visibility(
                  visible: summary,
                  child: Column(
                    children: [
                      Text(
                        'DONATION FOR ${widget.org!}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Will donate food?',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${food ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Will donate clothes?',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${clothes ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Will donate cash?',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${cash ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Will donate necessities?',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${necessities ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Needs Logistics?',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${logistics ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: logistics,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Other Donation",
                                  labelText: "Others",
                                ),
                                controller: _others,
                                validator: _validateOther,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addEntry(context);
                        },
                        child: const Text('Donate', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
