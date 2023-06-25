import 'package:health_app/domain/data/partner_data.dart';

class PointData{
  final PartnerData partnerData;
  final double lat;
  final double lon;
  PointData({required this.partnerData, required this.lat, required this.lon});
}