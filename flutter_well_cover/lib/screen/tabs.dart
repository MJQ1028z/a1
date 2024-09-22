import 'package:flutter/material.dart';
import 'package:flutter_well_cover/screen/map.dart';
import 'package:flutter_well_cover/screen/my_setting.dart';
import 'package:flutter_well_cover/screen/setting.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
  });

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MapScreen();
    var activePageTitle = "地图";
    if (_selectedPageIndex == 1) {
      activePage = const MySettingScreen();
      activePageTitle = '我的';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        backgroundColor: Colors.amber,
      ),
      drawer: const SettingScreen(),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '地图',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
