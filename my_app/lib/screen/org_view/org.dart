import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/organization_provider.dart';
import '../../provider/donation_provider.dart'; 
import 'donation_drives.dart';
import 'about_organization.dart';  
import '../../provider/auth_provider.dart';
import '../signin_page.dart';
import 'edit_status_page.dart'; 
import 'donations_to_organization.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class OrgPage extends StatefulWidget {
  @override
  _OrgPageState createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {
  @override
  Widget build(BuildContext context) {
    final organizationId = Provider.of<OrganizationIdProvider>(context).organizationId;
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Page'),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  await context.read<UserAuthProvider>().signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Consumer<DonationList>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DonationsToOrganizationPage(organizationId: organizationId),
                                ),
                              );
                            },
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.grey.withOpacity(0.5),
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                      child: Icon(
                                        Icons.stacked_line_chart_rounded,
                                        size: 48,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                      child: Text(
                                        "Donations",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DonationDrivesPage(organizationId: organizationId),
                                ),
                              );
                            },
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.grey.withOpacity(0.5),
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                      child: Icon(
                                        Icons.swap_horiz_outlined,
                                        size: 48,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                      child: Text(
                                        "Donation Drives",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutOrganizationPage(organizationId: organizationId),
                                ),
                              );
                            },
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.grey.withOpacity(0.5),
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                      child: Icon(
                                        Icons.stacked_line_chart_rounded,
                                        size: 48,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                      child: Text(
                                        "Profile",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
                SizedBox(height: 20.0), // Add space between buttons and donation list
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: provider.getDonationsbyOrg(userAuthProvider.organizationId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No donations found.'));
                      } else {
                        final donations = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: donations.length,
                          itemBuilder: (context, index) {
                            final donation = donations[index];
                            return ListTile(
                              title: Text('Donation ID: ${donation.id}'),
                              subtitle: Text('Status: ${donation['Status']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditStatusPage(donationId: donation.id),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

                       
