import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:provider/provider.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Login_Screen.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/modules/Add_Post.dart';
import 'package:social_test/Social/modules/Chats.dart';
import 'package:social_test/Social/modules/Home.dart';
import 'package:social_test/Social/modules/Profile.dart';
import 'package:social_test/Social/modules/reports.dart';
import 'package:social_test/main.dart';

///

List<Widget> Screens = [
  const Home(),
  const Chats(),
  const Reports(),
];

class Social_Layout extends StatelessWidget {
  const Social_Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..GetPostsData(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is Delete_Post_Success)
            Snake(
                titleWidget: const Text("Your post is successfully deleted"),
                context: context,
                EnumColor: Messages.Success);
          if (state is Delete_Post_Failure)
            Snake(
                titleWidget: const Text("Your post doesn't been deleted"),
                context: context,
                EnumColor: Messages.Error);
        },
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return Scaffold(
                  floatingActionButton: cubit.currentIndex != 0
                      ? null
                      : FloatingActionButton(
                          onPressed: () {
                            Navigat(context, const Adding_Post());
                          },
                          backgroundColor: const Color(0xffFF7F50),
                          child: const Icon(Icons.add,color: Colors.white,),
                        ),
                  bottomNavigationBar: BottomNavigationBar(selectedItemColor: Colors.blue,
                    currentIndex: cubit.currentIndex,
                    onTap: (value) => cubit.BottomNavigation(value,context),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(
                          IconBroken.Home,
                        ),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          IconBroken.Chat,
                        ),
                        label: "Messeges",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          IconBroken.Info_Circle,
                        ),
                        label: "Reports",
                      ),
                    ],
                  ),
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            Provider.of<ThemeProvide>(context, listen: false)
                                .changeMode();
                          

                            // NavigatReplace(context,
                            //     MyApp(isDark: SocialCubit.get(context).isDark));
                          },
                          icon: Icon(Provider.of<ThemeProvide>(context).isDark
                              ? Icons.light_mode
                              : Icons.dark_mode))
                    ],
                    leading: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Text("Profile"),
                            onTap: () {
                              Navigat(context, const Profile());
                            },
                          ),
                          PopupMenuItem(
                              child: const Text("Log Out"),
                              onTap: () {
                                SignOut(key: "uId");
                                Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .isDark = false;
                                Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .notifyListeners();

                                NavigatReplace(context, const LoginScreen());
                                LoginCubit.get(context).gottenData = null;
                              }),
                        ];
                      },
                    ),
                    centerTitle: true,
                    title:   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Mawja",
                          style: GoogleFonts.montserrat (letterSpacing: 2,fontStyle: FontStyle.italic,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                        
                            // color: Colors.black
                          ),
                          // style: TextStyle(
                          //     color: Color(0xff9E0093),
                          //     fontFamily: "0",
                        
                          //     fontSize: 40),
                        ),
                        const SizedBox(width: 10,),

                        Column(
                          children: [
                            const SizedBox(height: 10,),
                            // Image.asset("images/freepik-minimalist-deep-blue-ocean-logo-20240908115413lkmP.png",height: 80,width: 80,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  body:  state is AppLoading || cubit.ListPostModel == null
              ? Container(
                
                  // color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              :  Screens[cubit.currentIndex]);
        },
      ),
    );
  }
}
