import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:salas_hands_on_semi_finals/todo_Details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list = <dynamic> [];

  @override
  void initState(){
    super.initState();
        getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hands On Semi Final'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          final item = list[index] as Map;
          return Dismissible(
            key: ValueKey(item[index]),
            background: slideBackground(),
            confirmDismiss: (direction) async {
              final bool res = await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                      "Delete To-do ${list[index]['title']}?"
                    ),
                    actions: <Widget>[
                      FloatingActionButton(
                        child: const Icon(
                        Icons.check,
                      color: Colors.white,
                      ),
                        onPressed: () {
                          setState(() {
                            list.removeAt(index);
                            }
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      FloatingActionButton(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            list.removeAt(index);
                            }
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              );
              return res;
            },
            child: ListTile(
              leading: Text('${index + 1}'),
              title: Text(list[index]['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              subtitle: Text(list[index]['body']),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TodoDetails(todo: list[index])
                  )
                );
              },
            ),
          );
        },
      )
    );
  }
  Future <void> getTodos() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(url);
    setState(() {
      list = convert.jsonDecode(response.body) as List;
      }
    );
  }
  Future<void> deleteTodo(String id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      final filtered = list.where((e) => e['_id'] != id).toList();
      setState(() {
        list = filtered;
        }
      );
    }
    getTodos();
  }
    Future <void> todoDetails() async {
      final route = MaterialPageRoute(
      builder: (context) => TodoDetails(todo: list),
    );
    await Navigator.push(context, route);
    getTodos();
  }
  Widget slideBackground() {
    return Container(
      color: Colors.black,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
