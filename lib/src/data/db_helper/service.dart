import 'package:triptale/src/data/db_helper/db_repository.dart';

class ExpanseService {
  late DBRepository _dbRepository;
  ExpanseService() {
    _dbRepository = DBRepository();
  }
  saveExpanseMaster(data) async {
    return await _dbRepository.insertData("TripExpanseMaster", data);
  }

  getExpanseMaster() async {
    return await _dbRepository.readData("TripExpanseMaster");
  }
}
