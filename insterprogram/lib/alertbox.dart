import 'package:flutter/material.dart';

class ShowAlterDialog extends StatelessWidget {
  String alert;
   ShowAlterDialog({super.key,required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: SizedBox(
          height:MediaQuery.of(context).size.height*0.4,
          child: AlertDialog(content:Column(
            children:[
              Text(alert),
              ElevatedButton(onPressed:(){
                Navigator.pop(context);
                }, child:const Text('Ok')
                )
            ],
          )),
        ),
      ),
    );
  }
}