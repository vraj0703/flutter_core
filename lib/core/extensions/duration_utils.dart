extension DurationExtensions on int {
  Duration get delayMs => Duration(milliseconds: this);

  Duration get animateMs => Duration(milliseconds: this);

  DateTime get dateTime {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
