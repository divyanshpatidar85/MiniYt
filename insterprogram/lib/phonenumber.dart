import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insterprogram/alertbox.dart';
import 'package:insterprogram/otpverify.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController phonenumberController = TextEditingController();
  String? phonenumber;
  String? _verificationId;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: phonenumberController,
                keyboardType: TextInputType.number,
                onChanged: (em) {
                  setState(() {
                    phonenumber = phonenumberController.text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  label: const Text('Phone Number'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed:isLoading ? null:() async {
                  if (!isLoading) {
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+91${phonenumberController.text}',
                        verificationCompleted: (PhoneAuthCredential credential) {
                          // Navigator.push(context, MaterialPageRoute(builder:(context) =>const OtpVerifier(),));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          setState(() {
                            isLoading = false;
                          });
                          ShowAlterDialog(alert: '${e.message}',);
                          Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowAlterDialog(alert: '${e.message}')));
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          print('Code Sent');
                          setState(() {
                            _verificationId = verificationId;
                          });
                          print(_verificationId);
                            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                           OtpVerifier(otp:_verificationId!,)
                    )
                            );
                            
                        },
                        
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      
                    } catch (e) {
                      print('Error during verification: $e');
                    }finally{
                      // isLoading=false;
                      // setState(() {
                        
                      // });
                    }
                    
                  }
                },
                child: Text(isLoading ? 'Verifying...' : 'Verify Your Mobile Number'),
              ),
              if (isLoading) const CircularProgressIndicator() else Container(),
            ],
          ),
        ),
      ),
    );
  }
}
