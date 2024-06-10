import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart';
import '../../provider/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  final String? email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedAddress;
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

    @override
  void initState() {
    super.initState();
    // Fetch donor details when the widget is initialized
    final donorProvider = Provider.of<DonorProvider>(context, listen: false);
    donorProvider.fetchDonorDetails(widget.email!);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

 Future<void> _showAddAddressDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Address Type'),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_typeController.text.isNotEmpty && _addressController.text.isNotEmpty) {
                  await Provider.of<DonorProvider>(context, listen: false)
                      .addAddress(widget.email!, _typeController.text, _addressController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorProvider()..fetchDonorDetails(widget.email!),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
        ),
        body: Consumer<DonorProvider>(
          builder: (context, provider, child) {
            if (provider.name.isEmpty && provider.email.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(24.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Example custom font
                      ),
                    ),
                    SizedBox(height: 32), // Increased spacing
                    Text(
                      'Email: ${provider.email}',
                      style: const TextStyle(
                        fontSize: 20, // Increased font size
                        fontFamily: 'Roboto', // Example custom font
                      ),
                    ),
                    SizedBox(height: 32),  
                    Text(
                      'Contact number: ${provider.contact}',
                      style: const TextStyle(
                        fontSize: 20, // Increased font size
                        fontFamily: 'Roboto', // Example custom font
                      ),
                    ),
                    SizedBox(height: 32),
                    DropdownButton<String>(
                      value: _selectedAddress,
                      hint: Text('Addresses'),
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
                    ),
                    SizedBox(height: 32), // Increased spacing
                    ElevatedButton(
                      onPressed: _showAddAddressDialog,
                      child: Text('Add Address'),
                    ),
                  ],

                ),
              );
            }
          },
        ),
      ),
    );
  }
}
