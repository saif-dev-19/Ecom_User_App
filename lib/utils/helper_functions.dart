import 'package:intl/intl.dart';

String get genarateOrderId => "Order_$getFormattedCurrentDate";

String get getFormattedCurrentDate => DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());