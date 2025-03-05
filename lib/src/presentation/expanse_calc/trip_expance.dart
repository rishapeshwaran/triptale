import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:triptale/src/data/dtos/expanse_master_dto.dart';
import 'package:triptale/src/data/repository/expanse_repository.dart';

class TripExpance extends ConsumerStatefulWidget {
  const TripExpance({super.key});

  @override
  ConsumerState<TripExpance> createState() => _TripExpanceState();
}

class _TripExpanceState extends ConsumerState<TripExpance> {
  bool _isBottomSheet = false;
  TextEditingController _dateController = TextEditingController();
  bool _isPerHead = false;
  TextEditingController _perHeadController = TextEditingController();
  TextEditingController _expanseNameController = TextEditingController();
  TextEditingController _amoutController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? currentExpanseId = ref.watch(currentExpanseProvider);
    List<TripExpanseMaster> tripExpanseMasterList =
        ref.watch(expanseMasterProvider);
    TripExpanseMaster tripExpanse = ref.watch(expanseMasterProvider).firstWhere(
          (element) => element.id == currentExpanseId,
        );
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
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('Add Expense'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _expanseNameController,
                                      decoration:
                                          InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _amoutController,
                                      decoration:
                                          InputDecoration(labelText: 'Amount'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    // TextFormField(
                                    //   decoration: InputDecoration(
                                    //       labelText: 'Quantity'),
                                    //   keyboardType: TextInputType.number,
                                    // ),
                                    TextFormField(
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                        labelText: "Date of Birth",
                                        suffixIcon: Icon(Icons.calendar_today),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () => _selectDate(context),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Date selection is required";
                                        }
                                        return null;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isPerHead,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isPerHead = value!;
                                            });
                                          },
                                        ),
                                        Text('Per Head'),
                                      ],
                                    ),
                                    // if (isPerHead)
                                    //   TextFormField(
                                    //     controller: perHeadController,
                                    //     decoration: InputDecoration(
                                    //         labelText: 'How much per head'),
                                    //     keyboardType: TextInputType.number,
                                    //   ),
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
                                      final newTripExpance = TripExpanse(
                                          title: _expanseNameController.text,
                                          amount: double.parse(
                                              _amoutController.text),
                                          date: DateTime.parse(
                                              _dateController.text),
                                          isPerHead: _isPerHead);
                                      tripExpanseMasterList
                                          .firstWhere((element) =>
                                              element.id == currentExpanseId)
                                          .expanseList
                                          .add(newTripExpance);
                                      // final updatedList = [
                                      //   ...tripExpanseMasterList
                                      // ];
                                      ref
                                          .read(expanseMasterProvider.notifier)
                                          .update((state) =>
                                              [...tripExpanseMasterList]);
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
                    },
                    child: Text("add +")),
                ElevatedButton(onPressed: () {}, child: Text(("remove -"))),
                ElevatedButton(onPressed: () {}, child: Text(("Split /"))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tripExpanse.expanseList.length,
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
