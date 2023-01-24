import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Service/cubit/LanguageCubit.dart';
import '../Service/state/LanguageState.dart';
import '../const.dart';
import 'SearchScreen.dart';
import 'ViewScreen.dart';
/*All Language Related Api*/
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> languagetranslate=[
    "हिंदी",
    "বাংলা",
    "తెలుగు",
    "मराठी",
    ""
  ];
  List<String> language=[
    "asset/language/Hindi.png",
    "asset/language/Bengali.png",
    "asset/language/Telugu.png",
    "asset/language/marathi.png",
    "asset/language/Odia.png",

  ];
  List<String> languageCode=["Hindi","Bengali","Telugu","Marathi","Odia"];
  @override
  void initState() {
    debugPrint("Hello World");
    context.read<LanguageCubit>().fetchLanguages();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    context.read<LanguageCubit>().fetchLanguages();
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Language"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black))
        ],
      ),
      body: BlocBuilder<LanguageCubit,LanguageState>(builder: (context,state){
        if(state is LanguageLoadedState){
         return GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.slider.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 3/2),
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context,PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) =>  ViewScreen(title: state.slider[index].data[index].languageName, url: '',),
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
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}")),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(state.slider[index].data[index].languageName,style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 14)),
                          Text(state.slider[index].data[index].languageName,style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18))
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return  Center(child: CircularProgressIndicator());
      }),

    );
  }
}
