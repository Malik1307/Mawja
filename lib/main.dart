import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Login_Screen.dart';
import 'package:social_test/Shared%20Prefrence/SharedPref.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';
import 'package:social_test/observer.dart';

String? uID;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Cache.initialize();
  bool isDark = await Cache.ReadData(key: "Mode") ?? false;
  print("Dark mode =$isDark");

  uID = await Cache.ReadData(key: "uId");
  if (uID != null) {
    print("uId:${uID!}");
  } else {
    print("uId is null");
  }

  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvide()..loadMode(),
    child: MyApp(
    ),
  ));
}

class ThemeProvide extends ChangeNotifier {
  bool isDark = false;

  void changeMode() async{
    isDark = !isDark;
  await  Cache.WriteData(key: "Mode", value: isDark);
    print('Theme mode changed: $isDark'); // Debugging log

    // Notify listeners to rebuild widgets listening to this provider
    notifyListeners();
  }

  Future<void> loadMode() async {
    // Load the dark mode from shared preferences
    isDark = await Cache.ReadData(key: "Mode") ?? false;

    // Notify listeners to rebuild widgets with the loaded theme
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  bool firstTime = true;
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvide>(
      builder: (context, value, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SocialCubit()

              // ..getAllUsers(),
              ),
          BlocProvider(
            create: (context) => LoginCubit()..GetData(),
          ),
        ],
        child:
            BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
          if (state is Change_Mode) {
            Snake(
                titleWidget: const Text("Changing Mode"),
                context: context,
                EnumColor: Messages.Success);

            // Update theme mode when state changes
            // SocialCubit.get(context).isDark = !SocialCubit.get(context).isDark;
          }
        }, builder: (context, state) {
          return MaterialApp(
            darkTheme: ThemeData.dark(),
            theme: value.isDark ? ThemeData.dark() : ThemeData.light(),

            // primarySwatch: Nanآش
            // ,

            // themeMode: isDark
            //     ? ThemeMode.dark
            //     : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: uID == null ? const LoginScreen() : const Social_Layout(),
          );
        }),
      ),
    );
  }
}

bool isDarkFunc(bool darkMode) => darkMode;
double Width(context) {
  return MediaQuery.of(context).size.width;
}

double Height(context) {
  return MediaQuery.of(context).size.height;
}
