import 'package:flutter/material.dart';
import 'state.dart';
import 'block.dart';

import 'settings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // todo: 暂时不显示标题栏
      // appBar: AppBar(
      //   actions: <Widget>[
      //     FutureBuilder<int?>(
      //       future: Storage.getInt('counterKey'),
      //       builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return CircularProgressIndicator();
      //         } else {
      //           return Text('Count: ${snapshot.data ?? 0}');
      //         }
      //       },
      //     ),
      //   ],
      // ),
      body: BlockWidget(),
      // 定义侧边栏
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         accountName: Text('用户名称'),
      //         accountEmail: Text('user@example.com'),
      //         currentAccountPicture: CircleAvatar(
      //           child: FlutterLogo(size: 42.0),
      //         ),
      //         otherAccountsPictures: <Widget>[
      //           CircleAvatar(
      //             child: Text('A'),
      //           ),
      //           // 可以添加更多的账户图片或删除这些部分
      //         ],
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('设置'),
      //         onTap: () {
      //           Navigator.pop(context); // 关闭侧边栏
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => SettingScreen()),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
