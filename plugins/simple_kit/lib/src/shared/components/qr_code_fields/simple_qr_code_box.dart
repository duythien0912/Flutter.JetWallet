import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../simple_kit.dart';
import '../../constants.dart';
import 'simple_skeleton_qr_loader.dart';

enum SQrCodePosition { below, above }

class SQrCodeBox extends StatelessWidget {
  const SQrCodeBox({
    Key? key,
    this.loading = false,
    required this.data,
  }) : super(key: key);

  final bool loading;
  final String data;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SSkeletonQrCodeLoader();
    } else {
      return QrImage(
        padding: EdgeInsets.zero,
        data: data,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        embeddedImage: const AssetImage(
          sQrLogo,
          package: 'simple_kit',
        ),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(90.r, 90.r),
        ),
        size: 200.r,
      );
    }
  }
}
