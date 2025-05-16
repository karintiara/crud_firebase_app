import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddEditScreen extends StatefulWidget {
  final String? docId;
  final String? name;
  final int? price;

  AddEditScreen({this.docId, this.name, this.price});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameCtrl.text = widget.name!;
    if (widget.price != null) _priceCtrl.text = widget.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docId == null ? 'Tambah Produk' : 'Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Nama Produk'),
              validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga Produk'),
              validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(widget.docId == null ? 'Tambah' : 'Update'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.docId == null) {
                    _firestoreService.addProduct(_nameCtrl.text, int.parse(_priceCtrl.text));
                  } else {
                    _firestoreService.updateProduct(widget.docId!, _nameCtrl.text, int.parse(_priceCtrl.text));
                  }
                  Navigator.pop(context);
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
