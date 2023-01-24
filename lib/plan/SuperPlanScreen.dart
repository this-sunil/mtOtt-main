import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/DashBoardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Service/model/subscriptionPlan.dart';

class SuperPlanScreen extends StatefulWidget {
  const SuperPlanScreen({Key? key}) : super(key: key);

  @override
  State<SuperPlanScreen> createState() => _SuperPlanScreenState();
}

class _SuperPlanScreenState extends State<SuperPlanScreen> with TickerProviderStateMixin{
  late TabController tabController;
  String mobile="";
  String basic="";
  String standard="";
  String premium="";
  int amount=0;
  String id="";
  String title="";
  Razorpay razorPay=Razorpay();
  List<SubscriptionPlan> data=[];
  subscription() async{
   final resp=await get(Uri.parse(subscriptionPlan));
   final result=subscriptionPlanFromJson(resp.body);
   if(resp.statusCode==200){
     data.clear();
     if(result.data.isNotEmpty){
       for(int i=0;i<result.data.length;i++){
         data.add(SubscriptionPlan(status: result.status, message: result.message, data: result.data));
       }
     }
   }
   else{
     debugPrint("Error in Api ${resp.statusCode} ${resp.request!.url}");
   }
   setState(() {});
  }
  buySubscriptionPlan(String planId) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String uid=pref.getString("uid").toString();
    debugPrint("Buy Subscription plan User Id $uid");
    final resp=await post(Uri.parse(buySubscriptionPlans),body: {"user_id":uid,"plan_id":planId});
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      debugPrint("Response Buy Plan ${resp.body}");
      if(result["status"]==true || result["message"]=="Plan is Not Expire, so still continue to watch"){
        Navigator.push(context,PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => const DashBoardScreen(title: appName),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      }
    }
    else{
      debugPrint("error in Api ${resp.request!.url} and ${resp.statusCode}");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    buySubscriptionPlan(id);


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  payment(int amount,String title) async{
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': amount*100,
      'name': title,
      'description': appName,
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      }
    };
    razorPay.open(options);
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void initState() {

    tabController=TabController(length: 4, vsync: this,initialIndex: 0);
    subscription();
    super.initState();
  }
  @override
  void dispose() {
    razorPay.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(

          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Choose your plan that's right",style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children:  [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.check),
                  ),
                  Text("Watch all you want. Ad-free",style: GoogleFonts.inter(fontSize: 16))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children:  [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.check),
                  ),
                  Text("Recommendations just for you.",style: GoogleFonts.inter(fontSize: 16))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children:  [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.check),
                  ),
                  Text("Changes or cancel your plan anytime",style: GoogleFonts.inter(fontSize: 16))
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 10),
                child: TabBar(

                  physics: const BouncingScrollPhysics(),

                  controller: tabController,
                    indicator: RectangularIndicator(

                      color: Colors.amber,
                      paintingStyle: PaintingStyle.fill,
                      bottomLeftRadius: 5,

                      strokeWidth: 5,
                      bottomRightRadius: 5,
                    ),
                    tabs: const [
                      Tab(
                        child: Text("Mobile"),
                      ),
                      Tab(
                        child: Text("Basic"),
                      ),
                      Tab(
                        child: Text("Standard"),
                      ),
                      Tab(
                        child: Text("Premium"),
                      ),

                    ]),
              ),
            ),
            Flexible(
              flex: 5,
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: [
                    data.isNotEmpty?mobilePlan():CircularProgressIndicator(),
                    data.isNotEmpty?basicPlan():CircularProgressIndicator(),
                    data.isNotEmpty?standardPlan():CircularProgressIndicator(),
                    data.isNotEmpty?premiumPlan():CircularProgressIndicator(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  extendedPadding: EdgeInsets.symmetric(horizontal: 150),
                  label: const Text("Next"),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

                  onPressed: (){
                    payment(amount,title);

                  }),
            )
          ],
        ),
      ),

    );
  }
  Widget mobilePlan(){
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        RadioListTile(value: "mobile", groupValue: mobile, onChanged: (val){
          setState(() {
            mobile=val.toString();
            basic="";
            standard="";
            premium="";
            title=mobile;
            id=data[0].data[1].id;
            amount=int.parse(data[0].data[1].price);
          });
        },
            subtitle:  Text("\u{20B9} ${data[0].data[1].price} (validity:${data[0].data[1].validity} days)"),
            title: const Text("Monthly Price")),

        Divider(),
        ListTile(title: const Text("Video Quality"),subtitle: const Text("Good"),
        ),

        Divider(),
        ListTile(title: const Text("Resolution"),subtitle: const Text("480p")),

      ],
    );
  }
  Widget basicPlan(){
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        RadioListTile(value: "basic", groupValue: basic, onChanged: (val){
          setState(() {
            mobile="";
            basic=val.toString();
            standard="";
            premium="";
            title=basic;
            id=data[0].data[0].id;
            amount=int.parse(data[0].data[0].price);
          });
        },
            subtitle:  Text("\u{20B9} ${data[0].data[0].price} (validity:${data[0].data[0].validity} days)"),
            title: const Text("Monthly Price")),

        Divider(),
       ListTile(title: const Text("Video Quality"),subtitle: const Text("Good"),
        ),

        Divider(),
        ListTile(title: const Text("Resolution"),subtitle: const Text("720p")),

      ],
    );
  }
  Widget standardPlan(){
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        RadioListTile(value: "standard", groupValue: standard, onChanged: (val){
          setState(() {
            mobile="";
            basic="";
            standard=val.toString();
            premium="";
            title=standard;
            amount=int.parse(data[0].data[1].price);
            id=data[0].data[1].id;
          });
        },
            subtitle:  Text("\u{20B9} ${data[0].data[2].price} (validity:${data[0].data[2].validity} days)"),
            title: const Text("Monthly Price")),

        Divider(),
        ListTile(title: const Text("Video Quality"),subtitle: const Text("Better"),
        ),

        Divider(),
        ListTile(title: const Text("Resolution"),subtitle: const Text("1080p")),


      ],
    );
  }
  Widget premiumPlan(){
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        RadioListTile(value: "premium", groupValue: premium, onChanged: (val){
          setState(() {
            mobile="";
            basic="";
            standard="";
            premium=val.toString();
            title=premium;
            id=data[0].data[3].id;
            amount=int.parse(data[0].data[3].price);
          });
        },
            subtitle:  Text("\u{20B9} ${data[0].data[3].price} (validity:${data[0].data[3].validity} days)"),
            title: const Text("Monthly Price")),

        Divider(),
        ListTile(title: const Text("Video Quality"),subtitle: const Text("Best"),
        ),

        Divider(),
        ListTile(title: const Text("Resolution"),subtitle: const Text("4k+HDR")),



      ],
    );
  }

}

