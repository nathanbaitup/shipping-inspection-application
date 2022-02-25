
import 'package:shipping_inspection_app/sectors/history/record.dart';

List<Record> records = [];

void addRecord(type, user, dateTime, section) {
  records.add(Record(type, user, dateTime, section));
}