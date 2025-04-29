class TripExpanseMaster {
  int? id;
  String title;
  String description;
  int numberOfMembers;
  DateTime? startDate;
  DateTime? endDate;
  double budget;
  List<TripExpanse> expanseList;

  TripExpanseMaster({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfMembers,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.expanseList,
  });

  Map<String, dynamic> tripExpanseMasterMap() {
    return {
      // 'id': id,
      'title': title,
      'description': description,
      'numberOfMembers': numberOfMembers,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'budget': budget,
      //'expanseList': expanseList.map((e) => e.tripExpanseMap()).toList(),
    };
  }
}

class TripExpanse {
  int? id;
  int? tripExMasterID;
  String title;
  double amount;
  bool isPerHead;
  DateTime date;

  TripExpanse({
    this.id,
    this.tripExMasterID,
    required this.amount,
    required this.isPerHead,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> tripExpanseMap() {
    return {
      'id': id,
      'title': title,
      'tripExMasterID': tripExMasterID,
      'amount': amount,
      'isPerHead': isPerHead,
      'date': date.toIso8601String(),
    };
  }
}
