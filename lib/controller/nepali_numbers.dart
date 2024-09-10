String convertToNepaliNumber(String input) {
  const Map<String, String> englishToNepaliDigits = {
    '0': '०',
    '1': '१',
    '2': '२',
    '3': '३',
    '4': '४',
    '5': '५',
    '6': '६',
    '7': '७',
    '8': '८',
    '9': '९',
  };

  String nepaliNumber = input.split('').map((char) {
    return englishToNepaliDigits[char] ?? char;
  }).join();

  return nepaliNumber;
}

String convertToEnglishNumber(String nepaliNumber) {
  const Map<String, String> nepaliToEnglishDigits = {
    '०': '0', 
    '१': '1', 
    '२': '2', 
    '३': '3',
    '४': '4', 
    '५': '5', 
    '६': '6', 
    '७': '7',
    '८': '8', 
    '९': '9'
  };

  final buffer = StringBuffer();
  
  for (int i = 0; i < nepaliNumber.length; i++) {
    String char = nepaliNumber[i];
    buffer.write(nepaliToEnglishDigits[char] ?? char);
  }
  
  return buffer.toString();
}
