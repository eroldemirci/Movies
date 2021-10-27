import '../models/movies_favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('favorites.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE favorites ( 
  id $idType, 
  movie_id $integerType,
  title $textType,
  poster_path $textType,
  vote_average $doubleType,
  time $textType  
  )
''');
  }

  Future<MoviesFavorite> addFavorite(MoviesFavorite favorite) async {
    final db = await instance.database;

    final id = await db.insert('favorites', favorite.toJson());
    return favorite.copy(id: id);
  }

  Future<MoviesFavorite> readFavorite(int movieId) async {
    final db = await instance.database;

    final maps = await db.query(
      'favorites',
      columns: [
        'id',
        'movie_id',
        'title',
        'poster_path',
        'vote_average',
        'time'
      ],
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );

    if (maps.isNotEmpty) {
      return MoviesFavorite.fromJson(maps.first);
    } else {
      throw Exception('ID $movieId not found');
    }
  }

  Future<List<MoviesFavorite>> readAllFavorites() async {
    final db = await instance.database;
    final orderBy = 'time ASC';
    final result = await db.query('favorites', orderBy: orderBy);
    return result.map((json) => MoviesFavorite.fromJson(json)).toList();
  }

  Future<int> update(MoviesFavorite favorite) async {
    final db = await instance.database;

    return db.update(
      'favorites',
      favorite.toJson(),
      where: 'movie_id = ?',
      whereArgs: [favorite.movieId],
    );
  }

  Future<int> delete(int movieId) async {
    final db = await instance.database;

    return await db.delete(
      'favorites',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
