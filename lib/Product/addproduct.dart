// Widget build(BuildContext context) {
//
//   return Scaffold(
//
//     drawer: drawerPage(),
//
//     appBar: AppBar(
//
//       title: Text('Product List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
//
//       backgroundColor: Colors.blueAccent,
//
//       elevation: 4,
//
//       actions: [
//
//         IconButton(
//
//           icon: Icon(Icons.add),
//
//           onPressed: () async {
//
//             final result = await Navigator.push(
//
//               context,
//
//               MaterialPageRoute(builder: (context) => AddProductPage()),
//
//             );
//
//             if (result == true) {
//
//               fetchProducts(); // Refresh products
//
//             }
//
//           },
//
//         ),
//
//       ],
//
//     ),
//
//   //   body: products.isEmpty
//   //
//   //       ? Center(
//   //
//   //     child: Text(
//   //
//   //       'No Products Found',
//   //
//   //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
//   //
//   //     ),
//   //
//   //   )
//   //
//   //       : ListView.builder(
//   //
//   //     itemCount: products.length,
//   //
//   //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//   //
//   //     itemBuilder: (context, index) {
//   //
//   //       final product = products[index];
//   //
//   //       return Padding(
//   //
//   //         padding: const EdgeInsets.symmetric(vertical: 6),
//   //
//   //         child: Card(
//   //
//   //           elevation: 6,
//   //
//   //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   //
//   //           child: Container(
//   //
//   //             decoration: BoxDecoration(
//   //
//   //               borderRadius: BorderRadius.circular(12),
//   //
//   //               gradient: LinearGradient(
//   //
//   //                 colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade700],
//   //
//   //                 begin: Alignment.topLeft,
//   //
//   //                 end: Alignment.bottomRight,
//   //
//   //               ),
//   //
//   //             ),
//   //
//   //             child: ListTile(
//   //
//   //               contentPadding: EdgeInsets.all(16),
//   //
//   //               title: Text(
//   //
//   //                 product['name'],
//   //
//   //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//   //
//   //               ),
//   //
//   //               subtitle: Column(
//   //
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //
//   //                 children: [
//   //
//   //                   Text(
//   //
//   //                     'Category: ${product['category']}',
//   //
//   //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
//   //
//   //                   ),
//   //
//   //                   SizedBox(height: 4),
//   //
//   //                   Text(
//   //
//   //                     'MRP: ₹${product['sellPrice']}',
//   //
//   //                     style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
//   //
//   //                   ),
//   //
//   //                   Text(
//   //
//   //                     'Sell Price: ₹${product['price']}',
//   //
//   //                     style: TextStyle(fontSize: 14, color: Colors.greenAccent, fontWeight: FontWeight.w500),
//   //
//   //                   ),
//   //
//   //                 ],
//   //
//   //               ),
//   //
//   //               trailing: PopupMenuButton<String>(
//   //
//   //                 onSelected: (value) {
//   //
//   //                   if (value == 'Edit') {
//   //
//   //                     Navigator.push(
//   //
//   //                       context,
//   //
//   //                       MaterialPageRoute(
//   //
//   //                         builder: (context) => EditProductPage(product: product),
//   //
//   //                       ),
//   //
//   //                     ).then((result) {
//   //
//   //                       if (result == true) {
//   //
//   //                         fetchProducts(); // Refresh products after editing
//   //
//   //                       }
//   //
//   //                     });
//   //
//   //                   } else if (value == 'Delete') {
//   //
//   //                     deleteProduct(product['id']); // Delete product
//   //
//   //                   }
//   //
//   //                 },
//   //
//   //                 itemBuilder: (context) => [
//   //
//   //                   PopupMenuItem(
//   //
//   //                     value: 'Edit',
//   //
//   //                     child: Row(
//   //
//   //                       children: [
//   //
//   //                         Icon(Icons.edit, color: Colors.blue),
//   //
//   //                         SizedBox(width: 8),
//   //
//   //                         Text('Edit'),
//   //
//   //                       ],
//   //
//   //                     ),
//   //
//   //                   ),
//   //
//   //                   PopupMenuItem(
//   //
//   //                     value: 'Delete',
//   //
//   //                     child: Row(
//   //
//   //                       children: [
//   //
//   //                         Icon(Icons.delete, color: Colors.red),
//   //
//   //                         SizedBox(width: 8),
//   //
//   //                         Text('Delete'),
//   //
//   //                       ],
//   //
//   //                     ),
//   //
//   //                   ),
//   //
//   //                 ],
//   //
//   //               ),
//   //
//   //             ),
//   //
//   //           ),
//   //
//   //         ),
//   //
//   //       );
//   //
//   //     },
//   //
//   //   ),
//   //
//   // );
//
// }