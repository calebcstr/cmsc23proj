import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  final String donationId;
  const QRImage(this.donationId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Generated QR Code'),
          centerTitle: true,
        ),
        body: Center(
          child: QrImageView(
            data: donationId,
            size: 300,
            // You can include embeddedImageStyle Property if you wanna embed an image from your Asset folder
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: const Size(
                300,
                300,
              ),
            ),
          ),
        ),
     );
   }
}