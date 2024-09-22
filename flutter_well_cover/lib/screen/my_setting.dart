import 'package:flutter/material.dart';

class MySettingScreen extends StatelessWidget {
  const MySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 15, top: 20),
              child: const Row(
                children: [
                  Icon(
                    IconData(0x10101, fontFamily: "styleIcons"),
                    size: 100,
                  ),
                  Text(
                    "已登录",
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 550,
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(5, 5),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //使用帮助
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0x100eb, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('使用帮助'),
                  trailing: const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                ),
                //清理缓存
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0xfc62, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('清理缓存'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                ),
                //关于我们
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0xfc59, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('关于我们'),
                  trailing: const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                ),
                //意见反馈
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0xfc3b, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('意见反馈'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                ),
                //账号安全
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0x100d0, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('账号安全'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                ),
                //退出登录
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    IconData(0xfc6a, fontFamily: 'styleIcons'),
                    color: Colors.blueAccent,
                  ),
                  title: const Text('退出登录'),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
