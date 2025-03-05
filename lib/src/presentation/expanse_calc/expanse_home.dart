import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:triptale/src/data/db_helper/service.dart';

import '../../data/dtos/expanse_master_dto.dart';
import '../../data/repository/expanse_repository.dart';
import 'trip_expance.dart';

class ExpanseCalcState extends ConsumerStatefulWidget {
  const ExpanseCalcState({super.key});

  @override
  ConsumerState<ExpanseCalcState> createState() => _ExpanseCalcStateState();
}

class _ExpanseCalcStateState extends ConsumerState<ExpanseCalcState> {
  var _expanseService = ExpanseService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAndSetExpanseMasters(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TripExpanseMaster> tripExpanseMasterList =
        ref.watch(expanseMasterProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              bool isPerHead = false;
              TextEditingController perHeadController = TextEditingController();
              TextEditingController titleController = TextEditingController();
              TextEditingController discriptionController =
                  TextEditingController();
              TextEditingController noOfMembersController =
                  TextEditingController();
              TextEditingController budgetController = TextEditingController();
              DateTimeRange? selectedDateRange;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Add Trip'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: discriptionController,
                            decoration:
                                InputDecoration(labelText: 'Discription'),
                            maxLines: 3,
                          ),
                          TextFormField(
                            controller: noOfMembersController,
                            decoration:
                                InputDecoration(labelText: 'No of Members'),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            controller: budgetController,
                            decoration: InputDecoration(labelText: 'Budget'),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            readOnly: true,
                            decoration:
                                InputDecoration(labelText: 'Date Range'),
                            onTap: () async {
                              DateTimeRange? pickedDateRange =
                                  await showDateRangePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1),
                              );
                              if (pickedDateRange != null) {
                                setState(() {
                                  selectedDateRange = pickedDateRange;
                                });
                              }
                            },
                            controller: TextEditingController(
                              text: selectedDateRange == null
                                  ? ''
                                  : '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final newTrip = TripExpanseMaster(
                              id: tripExpanseMasterList.length + 1,
                              title: titleController.text,
                              description: discriptionController.text,
                              numberOfMembers:
                                  int.parse(noOfMembersController.text),
                              startDate: selectedDateRange?.start,
                              endDate: selectedDateRange?.end,
                              budget: double.parse(budgetController.text),
                              expanseList: []);
                          // final updatedList = [
                          //   ...tripExpanseMasterList,
                          //   newTrip
                          // ];
                          // ref
                          //     .read(expanseMasterProvider.notifier)
                          //     .update((state) => updatedList);

                          var result = await _expanseService.saveExpanseMaster(
                              newTrip.tripExpanseMasterMap());
                          fetchAndSetExpanseMasters(ref);
                          print(result);
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
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Manage Trip Budget",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: tripExpanseMasterList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: InkWell(
                  onTap: () {
                    ref
                        .read(currentExpanseProvider.notifier)
                        .update((state) => tripExpanseMasterList[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripExpance(),
                        ));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 25,
                            child: Icon(Icons.flight_takeoff),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(tripExpanseMasterList[index].title),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                        "${DateFormat('MMM/dd').format(tripExpanseMasterList[index].startDate!)} to "),
                                    Text(DateFormat('MMM/dd').format(
                                        tripExpanseMasterList[index].endDate!)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Budget"),
                              SizedBox(height: 5),
                              Text(
                                  "₹${tripExpanseMasterList[index].budget.toStringAsFixed(2)}"),
                            ],
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
