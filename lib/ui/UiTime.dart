import 'package:flutter/material.dart';

class UiTime{

  TextStyle getBold(){
    return const TextStyle(fontWeight: FontWeight.bold,fontSize: 18);
  }

  TextStyle getBoldWhite(){
    return const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white);
  }

  Widget messageContainer(BuildContext context,data,String uid){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
      child: Container(
          alignment: (data['uid'] == uid)?Alignment.topRight:Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(10.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width/1.5,
                minHeight: 1,
                minWidth: 3,
                maxHeight: MediaQuery.of(context).size.width/2,
              ),
              decoration: BoxDecoration(
                  color: (data['uid'] != uid)?Colors.white:Colors.red,
                  border: Border.all(color: Colors.red, width: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(data["text"],style: (data['uid'] == uid)?getBoldWhite():getBold(),))
      ),
    );
  }

  Widget nameContainer(doc){
    print(doc["seen"].toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(doc["name"],style: getBold(),),
            (doc["seen"] <= doc["send"])? colorName("new", Colors.red): colorName("sent", Colors.green)
          ],
        ),
      ),
    );
  }

  Widget colorName(String text,Color c){
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: c,
          border: Border.all(color: Colors.red, width: 0.1),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Text(text),
    );
  }
}