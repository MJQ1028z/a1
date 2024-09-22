import 'dart:convert';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_well_cover/providers/data_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  final _listWell = [];
  bool isFirstData = true;

  void _httpGetWell() async {
    var url = Uri.parse(
        "https://iot-api.heclouds.com/thingmodel/query-device-property");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'version=2022-05-01&res=userid%2F351600&et=1764948513&method=sha1&sign=RT3TFXNhKvvkfyqw5LPT%2Fw0eiXk%3D',
    };
    var queryParams = {
      'product_id': 'krWIDw6HBR',
      'device_name': 'well01',
    };
    var urlWithParams = url.replace(queryParameters: queryParams);
    var response = await http.get(urlWithParams, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      for (var data in jsonData['data']) {
        if (isFirstData) {
          isFirstData = false; // 将标识设为false，跳过对第一个数据的处理
          continue; // 跳过对第一个数据的判断和处理，继续循环下一个数据
        }
        if (!_listWell.contains(data)) {
          setState(() {
            _listWell.add(data);
          });
        }
      }
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _httpGetWell();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listWell.clear();
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> value = ref.read(dataProvider);
    List<String?> snippets =
        value.map((marker) => marker.infoWindow.snippet).toList();
    print(snippets);
    Widget content = const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Text(
        '数据为空',
        textAlign: TextAlign.center,
      ),
    );
    if (_listWell.isNotEmpty) {
      content = SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                for (var well in _listWell)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      well['name'].toString(),
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                for (var well in _listWell)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      well['value'] == null
                          ? "${snippets[0]}"
                          : well['value'].toString(),
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("数据"),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
