// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:math';

import 'package:flutter_well_cover/providers/data_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_well_cover/config/config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  ///地图通信中心
  AMapController? mapController;

  ///定位插件
  AMapFlutterLocation? location;

  ///权限状态
  PermissionStatus? permissionStatus;

  ///相机位置
  CameraPosition? currentLocation;

  ///地图类型
  late MapType _mapType;

  var markerLatitude;
  var markerLongitude;

  double? meLatitude;
  double? meLongitude;

  ///天气请求
  String weatherTime = "";
  String weatherMsg = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    getWeather();
  }

  void initialize() async {
    _mapType = MapType.normal;

    /// 设置Android和iOS的apikey，
    AMapFlutterLocation.setApiKey(ConstConfig.androidKey, ConstConfig.iosKey);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyShow(true, true);
    requestPermission();
  }

  void requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        print("拒绝");
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        print("限制");
        break;
      default:
        print("其他状态");
        requestLocation();
        break;
    }
  }

  /// 请求位置
  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        /*print(event);*/
        double? latitude = double.tryParse(event['latitude'].toString());
        double? longitude = double.tryParse(event['longitude'].toString());
        markerLatitude = latitude.toString();
        markerLongitude = longitude.toString();
        meLatitude = latitude;
        meLongitude = longitude;
        if (latitude != null && longitude != null) {
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 17,
            );
          });
        }
      })
      ..startLocation();
  }

  void _onMapPoiTouched(AMapPoi poi) async {
    // ignore: unnecessary_null_comparison
    if (null == poi) {
      return;
    }
    /*print('_onMapPoiTouched===> ${poi.toJson()}');*/
    var xx = poi.toJson();
    /*print(xx['latLng']);*/
    markerLatitude = xx['latLng'][1];
    markerLongitude = xx['latLng'][0];
    /*print(markerLatitude);
    print(markerLatitude);*/
    _addMarker(poi.latLng!);
  }

  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};

//添加一个marker
  void _addMarker(LatLng markPostion) async {
    _removeAll();
    final Marker marker = Marker(
      position: markPostion,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      _markers[marker.id] = marker;
    });
    _changeCameraPosition(markPostion);
  }

  /// 清除marker
  void _removeAll() {
    if (_markers.isNotEmpty) {
      _markers.clear();
    }
  }

  /// 改变中心点
  void _changeCameraPosition(LatLng markPostion, {double zoom = 18}) {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          //中心点
          target: markPostion,
          //缩放级别
          zoom: zoom,
          //俯仰角0°~45°（垂直与地图时为0）
          tilt: 0,
          //偏航角 0~360° (正北方为0)
          bearing: 0,
        ),
      ),
      animated: true,
    );
  }

  void getWeather() async {
    await Future.delayed(const Duration(seconds: 1));
    var url = Uri.parse(
        "https://devapi.qweather.com/v7/weather/now?key=1233e353507746409c3340b228371442&location=$meLongitude,$meLatitude");

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // 请求成功
        var data = json.decode(response.body);
        String dateTimeString = data['now']['obsTime'];
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDateTime = dateFormat.format(
          DateTime.parse(dateTimeString),
        );
        var msg = data['now']['precip'];
        setState(() {
          weatherMsg = msg;
          weatherTime = formattedDateTime;
        });
      } else {
        // 请求失败
        print('请求失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      // 捕获异常
      print('发生异常：$e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    location?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> value = ref.read(dataProvider);
    return Scaffold(
      body: currentLocation == null
          ? Container(
              alignment: Alignment.center,
              child: const Text(
                "请选择地图",
                style: TextStyle(fontSize: 50),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        AMapWidget(
                          // 隐私政策包含高德 必须填写
                          privacyStatement: ConstConfig.amapPrivacyStatement,
                          apiKey: ConstConfig.amapApiKeys,
                          // 初始化地图中心店
                          initialCameraPosition: currentLocation!,
                          //定位小蓝点
                          myLocationStyleOptions: MyLocationStyleOptions(true),
                          // 普通地图normal,卫星地图satellite,
                          mapType: _mapType,
                          // 缩放级别范围
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(3, 20),
                          onPoiTouched: _onMapPoiTouched,
                          markers: Set<Marker>.of(
                            /*_markers.values*/
                            value,
                          ),
                          tiltGesturesEnabled: false,
                          // 地图创建成功时返回AMapController
                          onMapCreated: (AMapController controller) {
                            mapController = controller;
                          },
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                mapController?.moveCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(meLatitude!, meLongitude!),
                                    17,
                                  ),
                                );
                              });
                            },
                            child: const Icon(Icons.my_location),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      '时间:$weatherTime降水量:$weatherMsg',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        //带动画的按钮
        animatedIconTheme: const IconThemeData(size: 22.0),
        closeManually: false,
        //是否在点击子按钮后关闭展开项
        curve: Curves.bounceIn,
        //展开动画曲线
        overlayColor: Colors.black,
        //遮罩层颜色
        overlayOpacity: 0.5,
        //遮罩层透明度
        onOpen: () => print('OPENING DIAL'),
        //展开回调
        onClose: () => print('DIAL CLOSED'),
        //关闭回调
        tooltip: 'Speed Dial',
        //长按提示文字
        heroTag: 'speed-dial-hero-tag',
        //hero标记
        backgroundColor: Colors.amber,
        //按钮背景色
        foregroundColor: Colors.white,
        //按钮前景色/文字色
        elevation: 8.0,
        //阴影
        shape: const CircleBorder(),
        //shape修饰
        children: [
          //子按钮
          SpeedDialChild(
            label: '普通地图',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                getWeather();
                requestLocation();
                _mapType = MapType.normal;
              });
            },
          ),
          SpeedDialChild(
            label: '卫星地图',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                getWeather();
                requestLocation();
                _mapType = MapType.satellite;
              });
            },
          ),
        ],
      ),
    );
  }
}
