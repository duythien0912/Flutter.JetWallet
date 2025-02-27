import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../simple_kit.dart';

class SQrCodeBox extends StatelessWidget {
  const SQrCodeBox({
    Key? key,
    this.loading = false,
    required this.data,
    required this.qrBoxSize,
    required this.logoSize,
    this.showAlert = false,
    this.alert,
  }) : super(key: key);

  final bool loading;
  final String data;
  final double qrBoxSize;
  final double logoSize;
  final bool showAlert;
  final Widget? alert;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SSkeletonQrCodeLoader(
        size: qrBoxSize,
      );
    } else {
      return Column(
        children: [
          QrImage(
            data: data,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            embeddedImage: const AssetImage(
              sQrLogo,
              package: 'simple_kit',
            ),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(logoSize, logoSize),
            ),
            size: qrBoxSize,
          ),
          if (showAlert)
            alert!,
        ],
      );
    }
  }
}
