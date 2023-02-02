import 'package:flutter/material.dart';
import 'SideBar//SideMenuBar.dart';
//import 'package:';
//import 'package:auto_layout/auto_layout.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          backgroundColor: Colors.teal[900],
        ),
        body:ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            for (var i = 0; i < 5; i++) ...[
              Container(
                margin: EdgeInsets.only(left: 5, top: 30, right: 5, bottom: 5),
                height: 150,
                //width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 6,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                       flex: 3,
                       child: SizedBox(
                         height: 130,
                         child: Center(
                             child:  Image.network(
                               'https://picsum.photos/250?image=9',
                               //height: 150,
                               fit: BoxFit.fitHeight,
                             )
                         ),
                       ),
                   ),
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Flexible(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 10,top: 15),
                                //color: Colors.yellow,
                                height: 50,
                                child: Text("FutSoll",
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                              )),
                          Flexible(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                  padding: EdgeInsets.only(left: 10),
                                //color: Colors.green,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.red,
                                      size: 20.0,
                                    ),
                                    Text("FutSoll",
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 18))

                                  ],
                                )
                              )),
                          Flexible(
                              flex: 3,
                              child: Container(
                                //color: Colors.red,
                                child:  Padding(
                                    padding:const EdgeInsets.only(left: 10.0,top: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 45,
//color: Colors.green,
                                          child: Column(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.calendar_month,
                                                color: Colors.grey,
                                                size: 30.0,
                                              ),
                                              Text("22/dec",
                                                  style: TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: 50,
                                          width: 45,
//color: Colors.green,
                                          child: Column(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.timer,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                              Text("5:44p",
                                                  style: TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: 50,
                                          width: 45,
//color: Colors.green,
                                          child: Column(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.person,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                              Text("35",
                                                  style: TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: 50,
                                          width: 45,
//color: Colors.green,
                                          child: Column(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.person_add,
                                                color: Colors.green,
                                                size: 30.0,
                                              ),
                                              Text("5",
                                                  style: TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),

                                        ),
                                      ],
                                    )
                                ),
                              ))
                        ],
                      )
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 150,
                       // width: 100,
                        //color: Colors.red,
                        child: InkWell(
                          child: Container(
                              height: 150,
                              //width: 30,
                              color: Colors.teal[900],
                              child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Center(
                                    child: const Text("Apply",
                                        style: TextStyle(
                                            letterSpacing: 5,
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )),
                                  )
                              )
                          ),
                          onTap: (){
                            print("button pressed : ${i!}");
                          },
                        )
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

