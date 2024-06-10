import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/organization_provider.dart';
import '../../model/org_model.dart';
import 'drivepage.dart';

class Orgpage extends StatefulWidget {
  const Orgpage({super.key});
  static const routename = '/donationPage';

  @override
  State<Orgpage> createState() => _OrgpageState();
}

class _OrgpageState extends State<Orgpage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Available Organizations'),
      ),
      body: SafeArea(
        top: true,
        child: Consumer<OrganizationList>(
          builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child:
        StreamBuilder<List<Organization>>(
        stream: provider.getAllOpenOrganizations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("No Organizations Found"),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var organization = snapshot.data![index];

              return Dismissible(
                key: Key(organization.organizationId.toString()),
                child: ListTile(
                  title: Text(organization.organizationName),
                  leading: const Icon(Icons.business),
                  subtitle: Text('About: ${organization.description}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationDrivePage(orgId: organization.organizationId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ))]);}),
    ));
  }
}
