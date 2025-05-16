import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Produk',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    _nameController.text = '';
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Tambah Produk'),
              content: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      if (name.isNotEmpty) {
                        await _products.add({"name": name});
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Simpan"))
              ],
            ));
  }

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    _nameController.text = documentSnapshot['name'];
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Edit Produk'),
              content: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      if (name.isNotEmpty) {
                        await _products
                            .doc(documentSnapshot.id)
                            .update({"name": name});
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Update"))
              ],
            ));
  }

  Future<void> _delete(String id) async {
    await _products.doc(id).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Produk dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Produk')),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder:
              (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['name']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      _update(documentSnapshot)),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _delete(documentSnapshot.id)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _create,
          child: Icon(Icons.add),
        ));
  }
}