import 'package:intl/intl.dart';

class DistanceHelper {
  static final NumberFormat _formatter = new NumberFormat('0', 'fr_FR');

  static String getDistance(double dist) {
    if (dist > 1000) {
      return '~ ${_formatter.format(dist / 1000)} kms';
    } else if (dist <= 500) {
      return 'Moins de 500m';
    } else if (dist <= 1000) {
      return "Moins d'un km";
    }
    return '';
  }
}
