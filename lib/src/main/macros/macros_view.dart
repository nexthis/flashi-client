import 'package:flashi_client/src/services/firestore.dart';
import 'package:flashi_client/src/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MacrosView extends StatelessWidget {
  const MacrosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macros'),
      ),
      body: FutureBuilder<List<Macro>>(
        future: FirestoreService().macros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Container());
          } else if (snapshot.hasData) {
            var macros = snapshot.data!;
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: macros.length,
                itemBuilder: (context, index) {
                  return MacroItem(macro: macros[index]);
                },
              ),
              onRefresh: () => Future.delayed(const Duration(seconds: 1)),
            );
          } else {
            return const Text(
                'No macros found in account. Check your collection');
          }
        },
      ),
    );
  }
}

class MacroItem extends StatelessWidget {
  final Macro macro;
  const MacroItem({super.key, required this.macro});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Text(macro.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  style: buttonStyle,
                  onPressed: () => true,
                  icon: const Icon(Icons.delete)),
              IconButton(
                  style: buttonStyle,
                  onPressed: () => true,
                  icon: const Icon(Icons.remove_red_eye)),
              IconButton(
                  style: buttonStyle,
                  onPressed: () => true,
                  icon: const Icon(Icons.play_arrow)),
            ],
          )
        ]),
      ),
    );
  }
}
