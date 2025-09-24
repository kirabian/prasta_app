// import 'package:flutter/material.dart';

// class ActionButtons extends StatelessWidget {
//   final VoidCallback onCheckIn;
//   final VoidCallback onCheckOut;

//   const ActionButtons({
//     super.key,
//     required this.onCheckIn,
//     required this.onCheckOut,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Palet warna
//     const Color primaryColor = Color(0xFF347338);
//     const Color secondaryColor = Color(0xFFA5BF99);
//     const Color darkColor = Color(0xFF11261A);
//     const Color whiteColor = Colors.white;

//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: secondaryColor,
//               foregroundColor: darkColor,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             onPressed: onCheckIn,
//             icon: const Icon(Icons.login),
//             label: const Text("Check In"),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               foregroundColor: whiteColor,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             onPressed: onCheckOut,
//             icon: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationY(3.1416),
//               child: const Icon(Icons.logout),
//             ),
//             label: const Text("Check Out"),
//           ),
//         ),
//       ],
//     );
//   }
// }
