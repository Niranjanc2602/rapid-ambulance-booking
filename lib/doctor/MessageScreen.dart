import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/ui/UiTime.dart';

class MessageScreen extends StatefulWidget {
  final String userId;
  final String docId;
  final bool doctor;
  final String name;
  const MessageScreen({Key? key,required this.userId, required this.docId, required this.doctor, required this.name
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  DatabaseOp databaseOp = DatabaseOp();
  TextEditingController text = TextEditingController();
  UiTime ui = UiTime();
  AuthOp authOp = AuthOp();
  String? userId;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  void get()async{
    loading = true;
    var find = await databaseOp.message.doc("${widget.userId}-${widget.docId}").get();
    if (find.exists == false){
      await databaseOp.message.doc("${widget.userId}-${widget.docId}").set({
        "docId":widget.docId,
        "userId":widget.userId,
        "seen":0,
        "send":null,
        "name":await AuthOp().getUserName()
      });
    }
  }

  void send()async{
    databaseOp.sendMessage(text.text, widget.docId, widget.userId,widget.doctor);
    setState(() { text.clear();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/1.3,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: databaseOp.message.doc("${widget.userId}-${widget.docId}").collection("message").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else{
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (_, index){
                              return ui.messageContainer(context,docs[index],(widget.doctor == false)?widget.userId!:widget.docId);
                        });
                      }
                      }
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0,vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 0.1),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      height: 10,
                      width: MediaQuery.of(context).size.width/1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width-100,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Text message",),
                              controller: text,
                            ),
                          ),
                          IconButton(onPressed: send, icon: const Icon(Icons.send))
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
