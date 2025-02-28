import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            firstLogin INTEGER DEFAULT 1
          ); 
        ''');
    await db.execute('''
          CREATE TABLE pin(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pin TEXT
          );
        ''');
    await db.execute('''CREATE TABLE profile (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL,
      address TEXT NOT NULL,
      pin TEXT NOT NULL,
      imagePath TEXT
    )''');
    await db.execute('''
      CREATE TABLE business (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        address TEXT,
        description TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      sellPrice REAL NOT NULL,
      category TEXT NOT NULL,
      description TEXT
    )''');

    await db.execute('''CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )''');

    await db.execute('''CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      email TEXT
    )''');

    await db.execute('''CREATE TABLE payment_details (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (customer_id) REFERENCES customers (id),
      FOREIGN KEY (product_id) REFERENCES products (id)
    )''');
  }
  Future<bool> isFirstLogin() async {
    final db = await instance.database;
    final res = await db.query('users', limit: 1);
    if (res.isNotEmpty) {
      return res.first['firstLogin'] == 1;
    }
    return true; // If no user exists, it's a first login
  }
  Future<void> setFirstLoginCompleted() async {
    final db = await instance.database;
    await db.update('users', {'firstLogin': 0}, where: 'id = ?', whereArgs: [1]);
  }


  // User Management
  Future<int> registerUser(String username, String password) async {
    try {
      final db = await database;
      final res = await db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return res;
    }
    catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty ? res.first : null;
  }


  Future<bool> userExists(String username) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Pin Management
  Future<String?> getPin() async {
    final db = await database;
    final res = await db.query('pin', limit: 1);
    return res.isNotEmpty ? res.first['pin'] as String : null;
  }

  Future<int> savePin(String pin) async {
    final db = await database;
    final existingPin = await getPin();
    if (existingPin != null) {
      return await db.update('pin', {'pin': pin});
    } else {
      return await db.insert('pin', {'pin': pin});
    }
  }

  Future<int> deletePin() async {
    final db = await database;
    await db.update('users', {'firstLogin': 1});  // Logout state set karna
    return await db.delete('pin');
  }


  // Clear all data (Optional utility for debugging)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('pin');
  }


  Future<int> insertBusiness(Map<String, dynamic> business) async {
    final db = await instance.database;
    return await db.insert('business', business, conflictAlgorithm: ConflictAlgorithm.replace); // Yeh add kar
  }

  Future<int> updateBusiness(Map<String, dynamic> business) async {
    final db = await instance.database;
    return await db.update(
      'business',
      business,
      where: 'id = ?',
      whereArgs: [business['id']],
    );
  }


  Future<List<Map<String, dynamic>>> fetchBusinesses() async {
    final db = await instance.database;
    return await db.query('business');
  }


  Future<int> deleteBusiness(int id) async {
    final db = await instance.database;
    return await db.delete(
      'business',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<Map<String, dynamic>?> fetchProfile() async {
    final db = await instance.database;
    final result = await db.query('profile');
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.insert('profile', profile);
  }

  Future<int> updateProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.update(
      'profile',
      {
        'name': profile['name'],
        'email': profile['email'],
        'phone': profile['phone'],
        'address': profile['address'],
        'pin': profile['pin'],
        'imagePath': profile['imagePath'],
      },
      where: 'id = ?',
      whereArgs: [profile['id']],
    );
  }

  // CRUD for Categories
  // CRUD for Categories
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await instance.database;
    return await db.insert('categories', category);
  }


  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await instance.database;
    return await db.query('categories', orderBy: 'name ASC');
  }


  // CRUD for Products
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // CRUD for Customers
  //////////////////////
  //////////////////////
  //////////////////////
  // Insert new customer
  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer);
  }


  // Fetch all customers
  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final db = await instance.database;
    return await db.query('customers');
  }

  // Update customer details
  Future<int> updateCustomer(Map<String, dynamic> customerData) async {
    final db = await database;
    return await db.update(
      'customers',
      {
        'name': customerData['name'],
        'phone': customerData['phone'],
        'email': customerData['email'],
      },
      where: 'id = ?',
      whereArgs: [customerData['id']],
    );
  }




  // Delete a customer
  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // CRUD for Payment Details

  Future<int> insertPaymentDetail(Map<String, dynamic> paymentDetail) async {
    final db = await database; // Assuming database is initialized
    return await db.insert('payment_details', paymentDetail);
  }

  Future<List<Map<String, dynamic>>> fetchPaymentDetails() async {
    final db = await instance.database;
    return await db.rawQuery(''' 
    SELECT pd.id, pd.amount, pd.date, c.name AS customer_name 
    FROM payment_details pd
    INNER JOIN customers c ON pd.customer_id = c.id
  ''');
  }

  Future<int> updatePaymentDetail(Map<String, dynamic> paymentDetail) async {
    final db = await instance.database;
    return await db.update(
      'payment_details',
      paymentDetail,
      where: 'id = ?',
      whereArgs: [paymentDetail['id']],
    );
  }

  Future<int> deletePaymentDetail(int id) async {
    final db = await instance.database;
    return await db.delete(
        'payment_details',
        where: 'id = ?',
        whereArgs: [id],
        );}


}