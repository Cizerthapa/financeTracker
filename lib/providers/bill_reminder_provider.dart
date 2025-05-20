import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class BillReminder {
  final String id;
  final String title;
  final double amount;
  final DateTime startDate;
  final DateTime dueDate;
  String status;
  final String userId;

  BillReminder({
    required this.id,
    required this.title,
    required this.amount,
    required this.startDate,
    required this.dueDate,
    this.status = 'incomplete',
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'startDate': startDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'status': status,
    'userId': userId,
  };

  factory BillReminder.fromMap(Map<String, dynamic> map) => BillReminder(
    id: map['id'],
    title: map['title'],
    amount: (map['amount'] as num).toDouble(),
    startDate: DateTime.parse(map['startDate']),
    dueDate: DateTime.parse(map['dueDate']),
    status: map['status'],
    userId: map['userId'],
  );
}

class BillReminderProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BillReminderProvider(this.flutterLocalNotificationsPlugin) {
    tzdata.initializeTimeZones();
    _setupNepaliTimezone();
  }

  final List<BillReminder> _reminders = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<BillReminder> get reminders => List.unmodifiable(_reminders);

  Future<void> fetchReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('bill_reminders')
          .where('userId', isEqualTo: userId)
          .get();

      _reminders.clear();
      for (var doc in snapshot.docs) {
        _reminders.add(BillReminder.fromMap(doc.data()));
      }
    } catch (e) {
      debugPrint('Error fetching reminders: $e');
    }

    _isLoading = false;
    notifyListeners();

    await scheduleDailyNotificationForPendingBills();
  }

  Future<void> addReminder(BillReminder reminder) async {
    _reminders.add(reminder);
    notifyListeners();

    await _firestore
        .collection('bill_reminders')
        .doc(reminder.id)
        .set(reminder.toMap());

    await scheduleDailyNotificationForPendingBills();
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();

    await _firestore.collection('bill_reminders').doc(id).delete();
    await flutterLocalNotificationsPlugin.cancel(_getNotificationIdFromId(id));
  }

  Future<void> markAsComplete(String id) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].status = 'complete';
      notifyListeners();

      await _firestore
          .collection('bill_reminders')
          .doc(id)
          .update({'status': 'complete'});

      await flutterLocalNotificationsPlugin.cancel(_getNotificationIdFromId(id));
    }
  }

  void _setupNepaliTimezone() {
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
  }

  Future<void> scheduleDailyNotificationForPendingBills() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);

    for (var bill in _reminders) {
      if (bill.status == 'incomplete') {
        final daysLeft = bill.dueDate.difference(now).inDays;
        if (daysLeft >= 0 && daysLeft <= 3) {
          await _scheduleDailyBillNotification(bill);
        }
      }
    }
  }

  // Future<void> _scheduleDailyBillNotification(BillReminder bill) async {
  //   final notificationId = _getNotificationIdFromId(bill.id);
  //   final scheduledTime = _nextInstanceOfTenAMNepali();
  //
  //   const androidDetails = AndroidNotificationDetails(
  //     'bill_reminder_channel',
  //     'Bill Reminders',
  //     channelDescription: 'Notifications for pending bill reminders',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //
  //   const notificationDetails = NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     notificationId,
  //     'Bill Due Soon: ${bill.title}',
  //     'You have \$${bill.amount.toStringAsFixed(2)} due on ${bill.dueDate.toLocal().toString().split(' ')[0]}',
  //     scheduledTime,
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     payload: bill.id,
  //   );
  // }

  Future<void> _scheduleDailyBillNotification(BillReminder bill) async {
    final notificationId = _getNotificationIdFromId(bill.id);

    // In debug mode, schedule notification 5 seconds from now for quick testing
    final scheduledTime = kDebugMode
        ? tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5))
        : _nextInstanceOfTenAMNepali();

    const androidDetails = AndroidNotificationDetails(
      'bill_reminder_channel',
      'Bill Reminders',
      channelDescription: 'Notifications for pending bill reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Bill Due Soon: ${bill.title}',
      'You have \$${bill.amount.toStringAsFixed(2)} due on ${bill.dueDate.toLocal().toString().split(' ')[0]}',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: bill.id,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAMNepali() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  int _getNotificationIdFromId(String id) {
    return id.hashCode & 0x7FFFFFFF;
  }
}
