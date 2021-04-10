import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:telyportsample/Static/Location.dart';

class Database_Helper{
  Future<dynamic> CreateDB()async{
    final Future<Database> database = openDatabase(
        join(await getDatabasesPath(), 'location.db'),
        onCreate: (db, version) {
    return db.execute(
    "CREATE TABLE location(id INTEGER PRIMARY KEY, lat TEXT, long TEXT)",
    );}, version: 1,);
    return database;
  }
  Future<void> insertLocation(MyLocations locations,Database database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'location',
      locations.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<MyLocations>> location(Database database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('location');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MyLocations(
        id: maps[i]['id'],
        lat: maps[i]['lat'],
        long: maps[i]['long'],
      );
    });
  }

// Get a reference to the database.


}