extension CapitalizeWord on String {
  String capitalizeWord() {
    List<String> names = split(" ");
    String initials = "";
    int numWords = 2;

    for (var i = 0; i < numWords; i++) {
      initials += names[i][0].toUpperCase();
    }
    return initials;
  }
}
