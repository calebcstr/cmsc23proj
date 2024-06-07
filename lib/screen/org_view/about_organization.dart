  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../../provider/organization_provider.dart';
  import '../../provider/auth_provider.dart';

 class AboutOrganizationPage extends StatelessWidget {
  final String organizationId;

  AboutOrganizationPage({required this.organizationId});

  @override
  Widget build(BuildContext context) {
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => OrganizationProvider()..fetchOrganizationDetails('organizationId', userAuthProvider.organizationId!),
      child: Scaffold(
        appBar: AppBar(
          title: Text('About the Organization'),
        ),
        body: Consumer<OrganizationProvider>(
          builder: (context, provider, child) {
            return provider.organizationName.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(24.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.organizationName,
                    style: TextStyle(
                      fontSize: 28, // Increased font size
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Example custom font
                    ),
                  ),
                  SizedBox(height: 32), // Increased spacing
                  Text(
                    'Email: ${provider.email}',
                    style: TextStyle(
                      fontSize: 20, // Increased font size
                      fontFamily: 'Roboto', // Example custom font
                    ),
                  ),
                  SizedBox(height: 32), 
                  Text(
                    'Address: ${provider.address}',
                    style: TextStyle(
                      fontSize: 20, // Increased font size
                      fontFamily: 'Roboto', // Example custom font
                    ),
                  ),
                  SizedBox(height: 32), 
                  Text(
                    'Contact number: ${provider.contact}',
                    style: TextStyle(
                      fontSize: 20, // Increased font size
                      fontFamily: 'Roboto', // Example custom font
                    ),
                  ),
                  SizedBox(height: 32), // Increased spacing
                Row(
                    children: [
                      Text(
                        'Open for donations?        ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Default color
                        ),
                      ),
                      Text(
                        provider.isOpenForDonations ? 'Yes' : 'No',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: provider.isOpenForDonations ? Colors.green : Colors.red, // Color based on value
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Switch(
                          value: provider.isOpenForDonations,
                          onChanged: (value) {
                            provider.updateIsOpenForDonations(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
