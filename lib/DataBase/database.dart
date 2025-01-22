import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db'); // Updated database name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // Ensure version matches table changes
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create tables with provided schemas
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
      product_id INTEGER NOT NULL, -- Added product_id reference
      quantity INTEGER NOT NULL, -- Added quantity field
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (customer_id) REFERENCES customers (id),
      FOREIGN KEY (product_id) REFERENCES products (id)
    )''');
  }

  // CRUD for Categories
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await instance.database;
    return await db.insert('categories', category);
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await instance.database;
    return await db.query('categories');
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
  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer);
  }

  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final db = await instance.database;
    return await db.query('customers');
  }

  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.update(
      'customers',
      customer,
      where: 'id = ?',
      whereArgs: [customer['id']],
    );
  }

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
    return await db.insert('payments', paymentDetail);
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
    );
  }

  // Fetch invoice by ID with customer, product, and payment details
  Future<Map<String, dynamic>?> fetchInvoiceById(int id) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT 
      pd.id, 
      pd.amount, 
      pd.date, 
      pd.quantity, 
      c.name AS customer_name, 
      p.name AS product_name 
    FROM payment_details pd
    INNER JOIN customers c ON pd.customer_id = c.id
    INNER JOIN products p ON pd.product_id = p.id
    WHERE pd.id = ?
  ''', [id]);

    return result.isNotEmpty ? result.first : null;
  }

  fetchInvoiceProducts(int invoiceId) {

  }
  // Insert payment details (invoice)

// Insert each product added to the invoice
  Future<int> insertInvoiceProduct(Map<String, dynamic> productDetail) async {
    final db = await database;
    return await db.insert('invoice_products', productDetail);
  }
}
