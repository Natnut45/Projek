import 'package:flutter/material.dart';
import 'todos.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Pertemuan06Provider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void onSaveTodo(String title, String description, String startDate,
      String endDate, String category, BuildContext context) {
    final homePageState = context.findAncestorStateOfType<_MyHomePageState>();
    homePageState?.addTodo(title, description, startDate, endDate, category);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Pertemuan06Provider>(context);
    return MaterialApp(
      title: 'Todos',
      theme: prov.enableDarkMode == true ? prov.dark : prov.light,
      home: const MyHomePage(title: 'Todos'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selected = 'Home';
  int val = 0;
  int count = 0;
  final List<Todo> _originalTodos = [];
  List<Todo> _filteredTodos = [];
  String? _value;
  List<String> stuff = ['Work', 'Routine', 'Others'];

  void addTodo(String title, String description, String startDate,
      String endDate, String category) {
    setState(() {
      _originalTodos.add(Todo(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        isChecked: false,
      ));
      _filteredTodos = _originalTodos;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _selectedChip(String? value) {
    List<Todo> filter;
    if (value != null) {
      filter = _originalTodos
          .where((tile) => tile.category.contains(value))
          .toList();
    } else {
      filter = _originalTodos;
    }
    setState(() {
      _filteredTodos = filter;
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Pertemuan06Provider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: val,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_rounded),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            setState(() {
              selected = 'Home';
              val = value;
            });
          } else if (value == 1) {
            setState(() {
              selected = 'Chat';
              val = value;
            });
          } else if (value == 2) {
            setState(() {
              selected = 'Profile';
              val = value;
            });
          }
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          Icon(prov.enableDarkMode == true
              ? Icons.wb_sunny
              : Icons.nightlight_round),
          Switch(
              value: prov.enableDarkMode,
              onChanged: (value) {
                setState(() {
                  prov.setBrightness = value;
                });
              })
        ],
      ),
      body: Column(children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  stuff.length,
                  (int index) {
                    return ChoiceChip(
                      label: Text(stuff[index]),
                      selectedColor: Colors.redAccent,
                      selected: _value == stuff[index],
                      onSelected: (bool value) {
                        setState(() {
                          _value = value ? stuff[index] : null;
                        });

                        if (value) {
                          _selectedChip(stuff[index]);
                        } else {
                          _selectedChip(null);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = _filteredTodos[index];
              return ExpansionTile(
                leading: Checkbox(
                  value: todo.isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isChecked = value ?? false;
                    });
                  },
                ),
                title: Text(
                  todo.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  '${todo.startDate} s/d ${todo.endDate}',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                children: <Widget>[
                  ListTile(
                      title: Text(
                    todo.description,
                  )),
                ],
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Todos(onSaveTodo: addTodo))));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String category;
  bool isChecked;

  Todo({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    this.isChecked = false,
  });
}

class Pertemuan06Provider extends ChangeNotifier {
  var light =
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.purple);
  var dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
  );
  bool _enableDarkMode = false;
  bool get enableDarkMode => _enableDarkMode;
  set setBrightness(val) {
    _enableDarkMode = val;
    notifyListeners();
  }
}
