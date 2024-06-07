import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../image_constants.dart';
import '../provider/auth_provider.dart';

class OrgSignUpPage extends StatefulWidget {
  const OrgSignUpPage({super.key});

  @override
  State<OrgSignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<OrgSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? organizationName;
  String? email;
  String? password;
  String? address;
  String? contactNo;
  String? errorMessage;
  String? proofOfLegitimacy;
  bool isOpenForDonations = true;
  bool isLoading = false;
  File? _imageFile;

  final Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                nameField,
                emailField,
                passwordField,
                addressField,
                contactNoField,
                isOpenForDonationsField,
                proofField,
                errorMessage != null ? signUpErrorMessage : Container(),
                isLoading ? const CircularProgressIndicator() : submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up as an Organization",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Organization Name",
            hintText: "Enter the organization name",
          ),
          onSaved: (value) => organizationName = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the organization name";
            }
            return null;
          },
        ),
      );
  
  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Enter an email",
          ),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter an email";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "At least 6 characters",
          ),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return "Please enter a valid password with at least 6 characters";
            }
            return null;
          },
        ),
      );

  Widget get addressField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Address",
            hintText: "Enter your address",
          ),
          onSaved: (value) => setState(() => address = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your address";
            }
            return null;
          },
        ),
      );

  Widget get contactNoField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Contact No",
            hintText: "Enter your contact number",
          ),
          onSaved: (value) => setState(() => contactNo = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your contact number";
            }
            return null;
          },
        ),
      );


  Widget get isOpenForDonationsField => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Open for Donations:",
            style: TextStyle(fontSize: 16),
          ),
          Switch(
            value: isOpenForDonations,
            onChanged: (bool value) {
              setState(() {
                isOpenForDonations = value;
              });
            },
          ),
        ],
      ),
    );

  Widget get proofField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Proof of Legitimacy",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        _imageFile != null
            ? Image.file(_imageFile!)
            : ElevatedButton(
          onPressed: _pickImage,
          child: const Text("Choose File"),
        ),
      ],
    ),
  );


  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            setState(() {
              isLoading = true;
            });
            try {
              String organizationId = uuid.v4();
              String? result = await context
                  .read<UserAuthProvider>()
                  .authService
                  .signUpOrganization(
                    organizationName!,
                    email!,
                    password!,
                    address!,
                    contactNo!,
                    organizationId,
                    proofOfLegitimacy,
                    isOpenForDonations, // Pass the new field
                  );
              if (mounted) {
                Navigator.pop(context);
              } else {
                setState(() {
                  errorMessage = result;
                });
              }
            } catch (e) {
              setState(() {
                errorMessage = 'An unexpected error occurred';
              });
            } finally {
              setState(() {
                isLoading = false;
              }); 
            }
          }
        },
        child: const Text("Sign Up"),
      );

  Widget get signUpErrorMessage {
    String message = errorMessage ?? "An error occurred";
    switch (errorMessage) {
      case 'invalid-email':
        message = 'Invalid email format!';
        break;
      case 'weak-password':
        message = 'Weak password, try a stronger one!';
        break;
      case 'email-already-in-use':
        message = 'Email already in use, please use a different email!';
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Future<void> _pickImage() async {
   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      String base64Image = ImageConstants().convertToBase64(_imageFile!);
      setState(() {
        proofOfLegitimacy = base64Image;
      });
    } else {
      print('No image selected.');
    }
  }
}