import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Donation {
  //All the variables that are needed to be shown in the summary are placed here
  final bool checkFood;
  final bool checkClothes;
  final bool checkCash;
  final bool checkNecessities;
  final String others;
  final bool checkLogistics;
  final String date;
  final int contactNo;
  final double weight;


  const Donation({required this.checkFood, required this.checkClothes, required this.checkCash, required this.checkNecessities, required this.others, required this.checkLogistics, required this.date, required this.contactNo, required this.weight});
}

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});
  static const routename = '/donationPage';

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
//initializing constants
  bool summary = false;
  bool save = false;

//GlobalKey of SlamBook
  final _key = GlobalKey<FormState>();

  bool food = false;
  bool clothes = false;
  bool cash = false;
  bool necessities = false;
  bool logistics = false;
  int number = 0;
  double weight = 0;

//Text Controllers
  final TextEditingController _date = TextEditingController();
  final TextEditingController _others = TextEditingController();

//clears the text state of the inputted TextFormFields
  void clearTextField() {
  _date.clear();
  _others.clear();
}

// Dispose the controller when the widget is disposed
    @override
  void dispose() {
    _date.dispose();
    _others.dispose();
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
  }

  Donation? donation;
  
    void addEntry() {
    donation = Donation(
        checkFood: food,
        checkClothes: clothes,
        checkCash: cash,
        checkNecessities: necessities,
        others: _others.text,
        checkLogistics: _logistics1,
        date: _date.text,
        contactNo: number,
        weight: weight);
      Navigator.pop(context, donation);
  }

  bool _logistics1 = false;
  bool _logistics2 = false;

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
        title: const Text('Slambook'),
      ),
      drawer: Drawer( //Creates a drawer for the user
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Donation Box'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Homepage'),
                onTap: () {
                  Navigator.pop(context);
                  if (save == true) {
                    addEntry();
                  } else {
                    Navigator.pop(context, donation);
                  }
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


        buildCheckboxRow('Food', 'Donate food items', food, (bool? value) {
          }),

        buildCheckboxRow('Clothes', 'Donate any used or clothes that you are not using anymore', clothes, (bool? value) {
          }),

        buildCheckboxRow('Cash', 'Donate amount of cash', cash, (bool? value) {
          }),

        buildCheckboxRow('Necessities', 'Donate any necessities from hygiene kits and medications', necessities, (bool? value) {
          }),

        Divider(
          height:20
        ),
        Row(
          children: [
          Expanded(
          child: buildCheckbox("For Delivery?", _logistics1, (bool? value) {
          })),
          Expanded(
          child: buildCheckbox("For Drop-off?", _logistics2, (bool? value) { 
        })),
          ]),

 // revise         
        /*Row(
        children: [
          Padding(
          padding: const EdgeInsets.all(10),
          child: Text(overflow: TextOverflow.ellipsis, 'Total Weight of Items')),
          Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(        
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter other items to donate",
              labelText: "Others",
            ),
            onChanged: (String value) {
              _others.text = value;
              print(_others.text);
            },
            controller: _others,
            validator: _validateOther
    ))]),*/
    

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
            const Text('SUMMARY',
          style: TextStyle(fontSize: 20.0, 
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,),
            Row(
          children: [const Expanded(
          child: Text('     Name',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(food.toString(),
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('     Nickname',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(clothes.toString(),
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('     Age',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(cash.toString(),
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('     Happiness',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(necessities.toString(),
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Row(
        children: [const Expanded(
          child: Text('     Superpower',
          style: TextStyle(fontSize: 15.0, 
          fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )),
        Expanded(
          child: Text(logistics.toString(),
          style: TextStyle(fontSize: 15.0,
          fontStyle: FontStyle.italic),
          textAlign: TextAlign.left,
        ))]),

        Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
                onPressed: () {
              addEntry();
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
                food = false;
                clothes = false;
                cash = false;
                necessities = false;
                summary = false;
                clearTextField();
               ;
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
