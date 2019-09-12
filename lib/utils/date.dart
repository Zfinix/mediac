import 'package:intl/intl.dart';

String formatDate(date) {
  if (date != null) {
    date = DateFormat('yyyy-MM-dd HH:mm:ss');

    return '${DateFormat('MMMM d').format(date)}, ${DateFormat("yyyy").format(date)}';
  } else {
    return '';
  }
}

int getAge(String date) {
  if (date != null) {
    var d = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(date);
    var dob = int.parse(DateFormat("yyyy").format(d));
    int currentYear = DateTime.now().year;
    return (currentYear - dob) ?? 0;
  } else {
    return 0;
  }
}

String formatTime(date) {
  if (date != null) {
    date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);

    return '${DateFormat("hh:mm a").format(date)} ';
  } else {
    return '';
  }
}
