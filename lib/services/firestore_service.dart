import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _productCollection = FirebaseFirestore.instance.collection('products');

  Stream<List<Map<String, dynamic>>> getProducts() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'price': data['price'],
        };
      }).toList();
    });
  }

  Future<void> addProduct(String name, int price) {
    return _productCollection.add({'name': name, 'price': price});
  }

  Future<void> updateProduct(String id, String name, int price) {
    return _productCollection.doc(id).update({'name': name, 'price': price});
  }

  Future<void> deleteProduct(String id) {
    return _productCollection.doc(id).delete();
  }
}
