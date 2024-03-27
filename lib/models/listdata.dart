import 'package:flutter/material.dart';

class Module {
  final String name;
  final String description;

  Module({required this.name, required this.description});
}

class ModuleListWidget extends StatelessWidget {
  final List<Module> modules;

  ModuleListWidget({required this.modules});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(modules[index].name),
          subtitle: Text(modules[index].description),
        );
      },
    );
  }
}



class ModuleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Module> modules = [
      Module(
        name: 'Mathematics',
        description: 'Learn about numbers and calculations.',
      ),
      Module(
        name: 'English',
        description: 'Improve your reading and writing skills.',
      ),
      Module(
        name: 'Science',
        description: 'Discover the wonders of the natural world.',
      ),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('School Modules'),
        ),
        body: ModuleListWidget(modules: modules),
      ),
    );
  }
}