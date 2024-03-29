import 'package:ai_assistent_app/bindings/init_binding.dart';
import 'package:ai_assistent_app/configs/routes.dart';
import 'package:ai_assistent_app/screens/calender_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Routes.pages,
      initialRoute: Routes.init,
      initialBinding: InitBinding(),
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(devicePixelRatio: 1),
          child: child ?? Container(),
        );
      },
    );
  }
}

// home: Scaffold(
//           body: SafeArea(
//               child: Padding(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const CalenderScreen()));
//                     },
//                     child: const Text('calender')),
//               ],
//             ),
//           )),
//         )