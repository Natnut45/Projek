import 'package:flutter/material.dart';

class Todos extends StatefulWidget {
  const Todos({Key? key, required this.onSaveTodo}) : super(key: key);

  final Function onSaveTodo;

  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  String dropdownvalue = 'Routine';
  final List<String> items = ['Routine', 'Work', 'Others'];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(5.0)),
              const Icon(Icons.list_alt_outlined),
              const Text('Kegiatan'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Judul Kegiatan',
                    )
                  ),
                ),
              )
            ],
          ),
          Row(
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Icon(Icons.notes),
              Text('Keterangan'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 20, 20),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tambah Keterangan'
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: const <Widget>[
                  Icon(Icons.date_range),
                  Text('Tanggal Mulai'),
                ],
              ),
              Row(
                children: const <Widget>[
                  Icon(Icons.date_range_outlined),
                  Text('Tanggal Selesai'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(20.0)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _startDateController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: '28-03-2023',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _endDateController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: '28-03-2023',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const <Widget>[
                  Icon(Icons.category),
                  Text('Kategori'),
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    }
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Batal'),
                  )
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      widget.onSaveTodo(
                        _titleController.text,
                        _descriptionController.text,
                        _startDateController.text,
                        _endDateController.text,
                        dropdownvalue
                      );
                      Navigator.pop(context, 'Data saved successfully.');
                    },
                    child: const Text('Simpan'),
                  )
                ),
              )
            ],
          )
        ],
      )
    );
  }
}