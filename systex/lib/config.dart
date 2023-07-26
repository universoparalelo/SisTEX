import 'package:url_launcher/url_launcher.dart';

String pathUrlBase = 'http://localhost:8000/';

//launch URL informes

void launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    print('Could not launch $url');
  }
}
