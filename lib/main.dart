import 'package:flutter/material.dart';
import 'package:theme/store/theme_store.dart';
import 'package:theme_app/store/theme_store.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'db/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.init();
  MultiProvider(providers: [
    Provider<ThemeStore>(create: (_) => ThemeStore()),
  ]);
  child:
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeStore = ThemeStore();

    return Provider(
      create: (_) => themeStore,
      child: Observer(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.yellow[70],
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
            ),
            themeMode: themeStore.isDark ? ThemeMode.dark : ThemeMode.light,

            home: const MainView(),
            // home: const FirstView(),
          );
        },
      ),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ThemeStore>(context);
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Theme Change'))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Observer(
            builder: (context) {
              return Center(
                child: Switch(
                  value: store.isDark,
                  onChanged: (val) {
                    store.toggleTheme(val);
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 200,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
