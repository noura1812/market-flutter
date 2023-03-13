import 'package:intl/intl.dart';

String calc(data) {
  DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(data);
  DateTime parsedDatenow = DateFormat("dd-MM-yyyy")
      .parse(DateFormat("dd-MM-yyyy").format(DateTime.now()));

  if (parsedDatenow == parsedDate) {
    data = 'Today';
  } else if (parsedDatenow.difference(parsedDate).inDays == 1) {
    data = 'Yasterday';
  } else if (parsedDatenow.difference(parsedDate).inDays == 2) {
    data = '2 Days ago';
  } else {
    data =
        DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy").parse(data));
  }
  return data;
}
