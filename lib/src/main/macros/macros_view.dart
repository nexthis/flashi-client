import 'package:flashi_client/src/services/firestore.dart';
import 'package:flashi_client/src/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flashi_client/src/widgets/connect_button.dart';
import 'package:provider/provider.dart';

import '../../providers/webrtc.dart';

class MacrosView extends StatefulWidget {
  const MacrosView({super.key});

  @override
  State<MacrosView> createState() => _MacrosViewState();
}

class _MacrosViewState extends State<MacrosView> {
  Future<List<Macro>> _data = FirestoreService().macros();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macros'),
        actions: const <Widget>[
          ConnectionButton(),
        ],
      ),
      body: FutureBuilder<List<Macro>>(
        future: _data,
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
              onRefresh: () async {
                setState(() {
                  _data = FirestoreService().macros();
                });
              },
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
                  onPressed: () {
                    context.read<WebRtcProvider>().send(macro.code);
                  },
                  icon: const Icon(Icons.play_arrow)),
            ],
          )
        ]),
      ),
    );
  }
}
