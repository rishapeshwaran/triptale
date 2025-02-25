import 'package:flutter/material.dart';

class TripExpance extends StatefulWidget {
  const TripExpance({super.key});

  @override
  State<TripExpance> createState() => _TripExpanceState();
}

class _TripExpanceState extends State<TripExpance> {
  bool _isBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _isBottomSheet
          ? Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border(),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Container(
                    height: 35,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox()),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _isBottomSheet = false;
                              });
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  )
                ],
              ),
            )
          : null,
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 200,
            child: Column(
              children: [
                Text("Pondy"),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          bool isPerHead = false;
                          TextEditingController perHeadController =
                              TextEditingController();

                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('Add Expense'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration:
                                          InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      decoration:
                                          InputDecoration(labelText: 'Amount'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Quantity'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isPerHead,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isPerHead = value!;
                                            });
                                          },
                                        ),
                                        Text('Per Head'),
                                      ],
                                    ),
                                    if (isPerHead)
                                      TextFormField(
                                        controller: perHeadController,
                                        decoration: InputDecoration(
                                            labelText: 'How much per head'),
                                        keyboardType: TextInputType.number,
                                      ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('CANCEL'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle the form submission logic here
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('ACCEPT'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                      ;
                      // setState(() {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return Container(
                      //         height: 400,
                      //         decoration: BoxDecoration(
                      //           border: Border(),
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(20),
                      //               topRight: Radius.circular(20)),
                      //           color: Theme.of(context)
                      //               .colorScheme
                      //               .secondaryContainer,
                      //         ),
                      //         child: Column(
                      //           children: [
                      //             SizedBox(height: 5),
                      //             Container(
                      //               height: 35,
                      //               child: Row(
                      //                 children: [
                      //                   Expanded(child: SizedBox()),
                      //                   IconButton(
                      //                       onPressed: () {
                      //                         setState(() {
                      //                           _isBottomSheet = false;
                      //                         });
                      //                       },
                      //                       icon: Icon(Icons.close))
                      //                 ],
                      //               ),
                      //             ),
                      //             Divider(
                      //               color: Colors.grey,
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   );
                      //   // _isBottomSheet = true;
                      // });
                    },
                    child: Text("add +")),
                ElevatedButton(onPressed: () {}, child: Text(("remove -"))),
                ElevatedButton(onPressed: () {}, child: Text(("Split /"))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    margin: EdgeInsets.all(0),
                    elevation: 5,
                    child: Container(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey))),
                            width: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("JAN"), Text("18")],
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Room Rent"),
                            ],
                          ),
                          SizedBox(width: 20)
                          // Container(
                          //   width: 80,
                          //   color: Colors.red,
                          //   child: Center(
                          //     child: Icon(Icons.currency_rupee),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
