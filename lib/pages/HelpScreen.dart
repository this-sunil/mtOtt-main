import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'SearchScreen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
        title: const Text("Help"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Contact No:9689658579"),
          ],
        ),
      ),
    );
  }
}
