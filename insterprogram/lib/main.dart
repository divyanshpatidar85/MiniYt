import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insterprogram/phonenumber.dart';
import 'package:insterprogram/videodisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:insterprogram/videodisplay.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  await Firebase.initializeApp(
    options:const FirebaseOptions
      (
      apiKey:"AIzaSyCawf6kUsXT2ZhNmmUv7DOphcJ9zm52gKI",
       appId:"1:193776849425:web:08d01c0dfdb675908a57b0", 
       messagingSenderId: "193776849425", 
       projectId: "internship-project-cb2a8",
       storageBucket: "internship-project-cb2a8.appspot.com",
       )
  
  
  );
  }else{
        // Firebase.initializeApp(
          await Firebase.initializeApp();
  }
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const MyHomePage(title: 'none',),
      
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  void updateBl(String value) {
    _MyHomePageState state = _MyHomePageState();
    state.updateBl(value);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String bl = 'Fail';
  @override
  void initState() {
    // updateBl('');
    super.initState();
    loadBl();
    // Load the value of bl from SharedPreferences
  }

  Future<void> loadBl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bl = prefs.getString('bl') ??
          ''; // Load the value from storage or use false if not found
    });
  }

  Future<void> updateBl(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bl', value); // Save the value to SharedPreferences
    setState(() {
      bl = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (bl == "") {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Fetching Your Account Details'),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (bl == 'Pass') {
              return const DisplayContent();
            }
          } else if (snapshot.hasError) {
            Text('${snapshot.error}');
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
                
              ),
            ),
          );
        }
        
        return const PhoneNumber();
      },
    )
        // body: AdminFacultyRegistration()
        );
  }
}

