import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_dynamic_linkss/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final goRouter = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return HomePage(key: state.pageKey);
        },
      ),
    ],
    redirect: (context, state) {
      print('redirect location: ${state.location}');
      return null;
    },
  );

  runApp(
    MaterialApp.router(
      routerConfig: goRouter,
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uri? _shortUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onCreateLinkTap,
              child: const Text('Create short link'),
            ),
            Text(_shortUrl == null ? '' : _shortUrl.toString()),
            ElevatedButton(
              onPressed: _shortUrl != null ? _onCopyLinkTap : null,
              child: const Text('Copy link'),
            ),
          ],
        ),
      ),
    );
  }

  void _onCreateLinkTap() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://firebasedynamiclinks.com/invite?code=123456"),
      uriPrefix: "https://firebasedynamiclinkss.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.example.firebasedynamiclinkss",
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.firebasedynamiclinkss",
      ),
    );

    final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    setState(() {
      _shortUrl = shortLink.shortUrl;
    });
  }

  void _onCopyLinkTap() {
    Clipboard.setData(ClipboardData(text: _shortUrl.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied Link!')),
    );
  }
}
