String maskIbanNumber({
  required String text,
}) {
  if (text.length < 24) {
    return text;
  }
  final lastFour = text.substring(text.length - 4);

  return lastFour.padLeft(15, '*');
}

