
import 'package:url_launcher/url_launcher_string.dart';

class MapLaunch{

  static Future<void> openMap(double lat, double lng)async{
    String mapUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    if(await canLaunchUrlString(mapUrl)){
      await launchUrlString(mapUrl);
    }else{
      throw 'could not launch';
    }
  }
}