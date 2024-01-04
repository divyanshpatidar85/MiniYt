import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:insterprogram/alertbox.dart';
import 'package:insterprogram/main.dart';
import 'package:insterprogram/videodisplay.dart';

class OtpVerifier extends StatefulWidget {
  final String otp;
  const OtpVerifier({super.key, required this.otp});

  @override
  State<OtpVerifier> createState() => _OtpVerifierState();
}

class _OtpVerifierState extends State<OtpVerifier> {
  
  @override
  Widget build(BuildContext context) {
    TextEditingController otptext=TextEditingController();
    return Scaffold(
          body:Column(
            children: [
               TextField(
                controller: otptext,
                keyboardType: TextInputType.number,
                
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  label: const Text('Enter OTP'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              ElevatedButton(onPressed:()async{
                // print('${widget.otp}');
                // if(widget.otp==otptext.text){
                 
                // }else{
                //   Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ShowAlterDialog(alert:"Enter Valid OTP")));
                 
                // }
                try{
               PhoneAuthCredential credential=await PhoneAuthProvider.credential(verificationId: widget.otp,smsCode:otptext.text.toString());
                FirebaseAuth.instance.signInWithCredential(credential).then((value){
                  MyHomePage(title:'').updateBl('Pass');
                   Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>const DisplayContent()
                )
                );
                }
               
                );
                }catch(e){
             
                }
              }, child:const Text("Submit"))
            ],
          ),
    );
  
  }
}