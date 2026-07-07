import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final _dateFormat = DateFormat('dd MMM yyyy', 'id');
  static final _timeFormat = DateFormat('HH:mm', 'id');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy HH:mm', 'id');

  static String currency(int amount) {
    return _currencyFormat.format(amount);
  }

  static String date(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return _dateFormat.format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String time(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return _timeFormat.format(dateTime);
    } catch (_) {
      return dateTimeStr;
    }
  }

  static String dateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return _dateTimeFormat.format(dateTime);
    } catch (_) {
      return dateTimeStr;
    }
  }

  static String seatNumbers(String? seatNumbers) {
    if (seatNumbers == null || seatNumbers.isEmpty) return '-';
    return seatNumbers;
  }

  static String bookingStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'cancelled':
        return 'Dibatalkan';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  static String paymentStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Lunas';
      case 'failed':
        return 'Gagal';
      case 'refunded':
        return 'Dikembalikan';
      default:
        return status;
    }
  }
}
