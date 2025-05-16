import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Produk')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final doc = products[index];
                return ListTile(
                  title: Text(doc['name']),
                  subtitle: Text('Rp ${doc['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => AddEditScreen(
                              docId: doc['id'],
                              name: doc['name'],
                              price: doc['price'],
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _firestoreService.deleteProduct(doc['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditScreen()));
        },
      ),
    );
  }
}
