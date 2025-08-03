import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QrDownloadScreen extends StatelessWidget {
  final String downloadUrl;

  const QrDownloadScreen({Key? key, required this.downloadUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("📱 Scan to download this app", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            QrImageView(
              data: downloadUrl,
              version: QrVersions.auto,
              size: 200.0,
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final Uri url = Uri.parse(downloadUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.download),
              label: const Text("Download APK"),
            ),
          ],
        ),
      ),
    );
  }
}
