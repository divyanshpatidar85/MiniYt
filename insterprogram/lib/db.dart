import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Db{
  Future<String> StoreInfo(String title,String description,String catagory,String downloadUrl) async{
    String res='Some error occured';
   final FirebaseFirestore _firestore=FirebaseFirestore.instance;
   try{
    String str=const Uuid().v1();
      _firestore.collection('VideoInfo').doc(str).set(
        {
          "title":title,
          "description":description,
          "catagory":catagory,
          "url":downloadUrl
        }
        
      );
      res="success";
   }catch(e){
  res=e.toString();
   }
    return res;
  }
}