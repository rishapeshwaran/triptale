import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptale/src/data/db_helper/service.dart';

import '../db_helper/db_repository.dart';
import '../dtos/expanse_master_dto.dart';

void fetchAndSetExpanseMasters(WidgetRef ref) async {
  // Obtain an instance of the DBRepository
  DBRepository dbRepository = DBRepository();

  // Read all records from the database
  var records = await dbRepository.readData("TripExpanseMaster");

  // Convert records to List<TripExpanseMaster>
  List<TripExpanseMaster> expanseMasters =
      records?.map<TripExpanseMaster>((record) {
            return TripExpanseMaster(
              id: record['id'],
              title: record['title'],
              description: record['description'],
              numberOfMembers: record['numberOfMembers'],
              startDate: record['startDate'] != null
                  ? DateTime.parse(record['startDate'])
                  : null,
              endDate: record['endDate'] != null
                  ? DateTime.parse(record['endDate'])
                  : null,
              budget: record['budget'],
              expanseList: [], // Populate this according to your data structure
            );
          }).toList() ??
          [];

  // Update the expanseMasterProvider with the fetched data
  ref.read(expanseMasterProvider.notifier).state = expanseMasters;
}

final expanseMasterProvider = StateProvider<List<TripExpanseMaster>>((ref) {
  return [];
});
final currentExpanseProvider = StateProvider<int?>((ref) {
  return;
});
