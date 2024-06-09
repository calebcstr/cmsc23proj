import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/donation_provider.dart';

class ProfilePage extends StatelessWidget {
  final String? email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorProvider()..fetchDonorDetails(email!),
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
                      'Address: ${provider.address}',
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
                    SizedBox(height: 32), // Increased spacing
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
