import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../settings/settings_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _ViewContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Login", style: textTheme.headline5),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, size: 35),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder()),
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.g_mobiledata, size: 35),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder()),
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.g_mobiledata, size: 35),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder()),
                      onPressed: () => {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(label: Text("Name/Email")),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(label: Text("Password")),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
                const Text("Create")
              ],
            ),
          )),
    );
  }
}

class _ViewContainer extends StatelessWidget {
  final Widget child;

  const _ViewContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            heightFactor: 0.6,
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: child),
            ),
          ),
        ));
  }
}
