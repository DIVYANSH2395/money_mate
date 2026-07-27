import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('moneymate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

   return await openDatabase(
  path,
  version: 2,
  onCreate: _createDB,
  onUpgrade: _onUpgrade,
);
  }

  Future _createDB(Database db, int version) async {

  // Transactions Table
  await db.execute('''
    CREATE TABLE transactions(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  type TEXT NOT NULL,
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  userEmail TEXT NOT NULL
)
  ''');

  // Users Table
  await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
  ''');

}

Future<void> _onUpgrade(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  if (oldVersion < 2) {
    await db.execute(
      "ALTER TABLE transactions ADD COLUMN userEmail TEXT NOT NULL DEFAULT ''",
    );
  }
}

  // =========================
  // Insert Transaction
  // =========================

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // =========================
  // Get All Transactions
  // =========================

  Future<List<TransactionModel>> getTransactions(
  String userEmail,
) async {
  final db = await instance.database;

  final result = await db.query(
    'transactions',
    where: 'userEmail = ?',
    whereArgs: [userEmail],
    orderBy: 'id DESC',
  );

  return result
      .map((json) => TransactionModel.fromMap(json))
      .toList();
}
  // =========================
  // Update Transaction
  // =========================

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await instance.database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // =========================
  // Delete Transaction
  // =========================

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// =========================
// Insert User
// =========================

Future<int> insertUser(UserModel user) async {
  final db = await instance.database;

  return await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.abort,
  );
}

// =========================
// Check Email Exists
// =========================

Future<bool> emailExists(String email) async {
  final db = await instance.database;

  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  return result.isNotEmpty;
}

// =========================
// Login User
// =========================

Future<UserModel?> loginUser(
  String email,
  String password,
) async {
  final db = await instance.database;

  final result = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  if (result.isNotEmpty) {
    return UserModel.fromMap(result.first);
  }

  return null;
}
Future<int> updatePassword(
  String email,
  String newPassword,
) async {
  final db = await database;

  return await db.update(
    "users",
    {
      "password": newPassword,
    },
    where: "email = ?",
    whereArgs: [email],
  );
}
// =========================
// Get User By Email
// =========================

Future<UserModel?> getUserByEmail(String email) async {
  final db = await instance.database;

  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return UserModel.fromMap(result.first);
  }

  return null;
}
  // =========================
  // Close Database
  // =========================

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

