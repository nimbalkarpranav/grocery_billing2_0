import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // Updated version to reflect the new tables
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE business (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        description TEXT,
        imagePath TEXT
      )
    ''');
    // Products Table
    await db.execute('''CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      sellPrice REAL NOT NULL,
      category TEXT NOT NULL,
      description TEXT
    )''');

    // Categories Table
    await db.execute('''CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )''');

    // Customers Table
    await db.execute('''CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      email TEXT
    )''');

    // Payment Details Table
    await db.execute('''CREATE TABLE payment_details (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (customer_id) REFERENCES customers (id)
    )''');
    await db.execute('''CREATE TABLE profile (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    pin TEXT NOT NULL,
    imagePath TEXT
  )''');
  }
  Future<int> insertBusiness(Map<String, dynamic> business) async {
    final db = await instance.database;
    return await db.insert('business', business);
  }
  Future<List<Map<String, dynamic>>> fetchBusinesses() async {
    final db = await instance.database;
    return await db.query('business');
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
  Future<int> deleteBusiness(int id) async {
    final db = await instance.database;
    return await db.delete(
      'business',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Insert Profile
  Future<int> insertProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.insert('profile', profile);
  }

// Fetch Profile
  Future<Map<String, dynamic>?> fetchProfile() async {
    final db = await instance.database;
    final result = await db.query('profile');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

// Update Profile
  Future<int> updateProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.update(
      'profile',
      profile,
      where: 'id = ?',
      whereArgs: [profile['id']],
    );
  }

// Delete Profile
  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    return await db.delete(
      'profile',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // Insert Category
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await instance.database;
    return await db.insert('categories', category);
  }

  // Fetch Categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await instance.database;
    return await db.query('categories');
  }

  // Insert Product
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;
    return await db.insert('products', product);
  }

  // Fetch Products
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }

  // Update Product
  Future<void> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',  // Correct table: 'products'
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // Insert Customer
  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer);
  }

  // Fetch Customers
  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final db = await instance.database;
    return await db.query('customers');
  }
  // Delete Customer
  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Update Customer
  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.update(
      'customers',
      customer,
      where: 'id = ?',
      whereArgs: [customer['id']],
    );
  }



  // Insert Payment Details
  Future<int> insertPaymentDetail(Map<String, dynamic> paymentDetail) async {
    final db = await instance.database;
    return await db.insert('payment_details', paymentDetail);
  }

  // Fetch Payment Details
  Future<List<Map<String, dynamic>>> fetchPaymentDetails() async {
    final db = await instance.database;
    return await db.query('payment_details');
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

// Delete Payment Details
  Future<int> deletePaymentDetail(int id) async {
    final db = await instance.database;
    return await db.delete(
      'payment_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
