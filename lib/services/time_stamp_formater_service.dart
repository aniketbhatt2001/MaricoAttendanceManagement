import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(dynamic firebaseValue) {
  // 1️⃣ Get a DateTime from whatever Firebase gives you
  DateTime dateTime;

  if (firebaseValue is Timestamp) {
    dateTime = firebaseValue.toDate(); // Firestore Timestamp ➜ DateTime
  } else if (firebaseValue is int) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        firebaseValue); // epoch ms ➜ DateTime
  } else if (firebaseValue is String) {
    dateTime = DateTime.parse(firebaseValue); // ISO‑8601 string ➜ DateTime
  } else {
    throw ArgumentError('Unsupported Firebase date type');
  }

  // 2️⃣ Format it
  final formatter = DateFormat('dd MMMM, yyyy hh:mm a');

  return formatter.format(dateTime);
}
