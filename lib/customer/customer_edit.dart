// import 'package:flutter/material.dart';
// import 'package:grocery_billing2_0/drawer/drawer.dart';
//
// import '../DataBase/database.dart';
// import 'customer_model.dart';
//
// class UpdateCustomer extends StatefulWidget {
//   final Customer customer;
//
//   const UpdateCustomer({super.key, required this.customer});
//
//   @override
//   _UpdateCustomerState createState() => _UpdateCustomerState();
// }
//
// class _UpdateCustomerState extends State<UpdateCustomer> {
//   late TextEditingController nameController;
//   late TextEditingController phoneController;
//   late TextEditingController emailController;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.customer.name);
//     phoneController = TextEditingController(text: widget.customer.phone);
//     emailController = TextEditingController(text: widget.customer.email);
//   }
//
//   void _updateCustomer() async {
//     if (nameController.text.isNotEmpty &&
//         phoneController.text.isNotEmpty &&
//         emailController.text.isNotEmpty) {
//       // Correcting the update call
//       await DBHelper.instance.updateCustomer(
//         widget.customer.id!,  // Passing ID correctly
//         {
//           'name': nameController.text,
//           'phone': phoneController.text,
//           'email': emailController.text,
//         },
//       );
//
//       Navigator.pop(context); // Go back to the customer list
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill in all fields")),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: drawerPage(),
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         // Custom AppBar color
//         title: Text(
//           "Update Customer",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(  // Allows scrolling for smaller devices
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Customer Name Field
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: "Customer Name",
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.blueAccent),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                 ),
//               ),
//               SizedBox(height: 16), // Spacing between fields
//
//               // Phone Number Field
//               TextField(
//                 controller: phoneController,
//                 decoration: InputDecoration(
//                   labelText: "Phone",
//                   prefixIcon: Icon(Icons.phone),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.blueAccent),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                 ),
//                 keyboardType: TextInputType.phone,
//               ),
//               SizedBox(height: 16), // Spacing between fields
//
//               // Email Field
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.blueAccent),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 32),
//
//               // Update Customer Button
//               ElevatedButton(
//                 onPressed: _updateCustomer,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,  // Custom button color
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 10,right: 10),
//                   child: Text(
//                     "Update Customer",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
