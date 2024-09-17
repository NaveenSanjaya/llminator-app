// For rootBundle


// Just for uploading the collection
/*
Future<void> uploadJsonData() async {
  try {
    // Load the JSON file from assets
    final String response = await rootBundle.loadString('assets/data.json');
    
    // Parse the JSON file
    final Map<String, dynamic> data = json.decode(response);

    // Get a Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Loop through each key in the JSON data
    for (var entry in data.entries) {
      final String docId = entry.key;
      final List<dynamic> values = entry.value;

      // Create a reference to the document with the specific ID
      DocumentReference documentRef = firestore.collection('candidates').doc(docId);

      // Create a map for the numbered values
      Map<String, dynamic> numberedData = {};
      for (int i = 0; i < values.length; i++) {
        numberedData[(i + 1).toString()] = values[i];
      }

      // Upload the data to Firestore
      await documentRef.set(numberedData);

      print('Data for document ID "$docId" uploaded successfully!');
    }
  } catch (e) {
    print('Error uploading data: $e');
  }
}
*/


