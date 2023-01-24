import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InternetConnection extends StatelessWidget {
  const InternetConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("asset/image/no-internet-connection.json",width: 200,height: 200),
            const Text("No Internet",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            const Text("Make sure you are connected to internet",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FloatingActionButton.extended(
                 extendedPadding: const EdgeInsets.symmetric(horizontal: 100),
                  onPressed: (){
                    BlocProvider.of<InternetCubit>(context).fetchInternetConnection();
              },label: const Text("Retry")),
            ),*/
          ],
        ),
      ),
    );
  }
}
