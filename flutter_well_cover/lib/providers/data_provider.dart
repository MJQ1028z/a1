import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Marker> initialMarkers = [
  Marker(
    position: const LatLng(22.74178, 114.228073),
    infoWindow: const InfoWindow(
      title: '井盖 1',
      snippet: '22.74178,114.228073',
    ),
    //使用默认hue的方式设置Marker的图标
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    position: const LatLng(22.742398, 114.228068),
    infoWindow: const InfoWindow(
      title: '井盖 2',
      snippet: '22.742398,114.228068',
    ),
    //使用默认hue的方式设置Marker的图标
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    position: const LatLng(22.742061, 114.229309),
    infoWindow: const InfoWindow(
      title: '井盖 3',
      snippet: '22.742061,114.229309',
    ),
    //使用默认hue的方式设置Marker的图标
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    position: const LatLng(22.743279, 114.229654),
    infoWindow: const InfoWindow(
      title: '井盖 4',
      snippet: '22.743279,114.229654',
    ),
    //使用默认hue的方式设置Marker的图标
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
];
final dataProvider = Provider((ref) {
  return initialMarkers;
});
