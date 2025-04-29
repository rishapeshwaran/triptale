import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_triptale');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String tripExMasterQuery = '''CREATE TABLE TripExpanseMaster (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    numberOfMembers INTEGER NOT NULL,
    startDate TEXT,
    endDate TEXT,
    budget REAL NOT NULL
    )''';
    await database.execute(tripExMasterQuery);

    String tripExDetailQuery = '''CREATE TABLE TripExpanseDetail(
	  id INTEGER PRIMARY KEY AUTOINCREMENT,
	  tripExMasterID INTEGER NOT NULL,
	  title TEXT NOT NULL,
	  amount REAL NOT NULL,
	  date TEXT,
    isPerHead INTEGER,
	  FOREIGN KEY(tripExMasterID) REFERENCES TripExpanseMaster(id) ON DELETE CASCADE
    )''';
    await database.execute(tripExDetailQuery);
  }
}
