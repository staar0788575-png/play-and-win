// user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String? email;
  final bool isVip;
  final DateTime? vipExpiryDate;
  final int balance; // رصيد العملات الذهبية
  final int dailyRoses; // الورود اليومية المتاحة
  final DateTime? lastRoseReset; // تاريخ آخر تجديد للورود
  final List<String> blockedUsers; // قائمة الـ UIDs للمستخدمين المحظورين

  UserModel({
    required this.uid,
    required this.username,
    this.email,
    this.isVip = false,
    this.vipExpiryDate,
    this.balance = 0,
    this.dailyRoses = 0,
    this.lastRoseReset,
    this.blockedUsers = const [],
  });

  // تحويل البيانات من خريطة Firestore إلى كائن Dart
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      username: map['username'] ?? '',
      email: map['email'],
      isVip: map['isVip'] ?? false,
      vipExpiryDate: (map['vipExpiryDate'] as Timestamp?)?.toDate(),
      balance: map['balance'] ?? 0,
      dailyRoses: map['dailyRoses'] ?? 0,
      lastRoseReset: (map['lastRoseReset'] as Timestamp?)?.toDate(),
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
    );
  }

  // تحويل كائن UserModel إلى خريطة لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'isVip': isVip,
      'vipExpiryDate': vipExpiryDate != null ? Timestamp.fromDate(vipExpiryDate!) : null,
      'balance': balance,
      'dailyRoses': dailyRoses,
      'lastRoseReset': lastRoseReset != null ? Timestamp.fromDate(lastRoseReset!) : null,
      'blockedUsers': blockedUsers,
    };
  }

  // دالة مساعدة لإنشاء نسخة معدلة من المستخدم بسهولة
  UserModel copyWith({
    String? username,
    bool? isVip,
    DateTime? vipExpiryDate,
    int? balance,
    int? dailyRoses,
    DateTime? lastRoseReset,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      uid: this.uid,
      username: username ?? this.username,
      isVip: isVip ?? this.isVip,
      vipExpiryDate: vipExpiryDate ?? this.vipExpiryDate,
      balance: balance ?? this.balance,
      dailyRoses: dailyRoses ?? this.dailyRoses,
      lastRoseReset: lastRoseReset ?? this.lastRoseReset,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}
