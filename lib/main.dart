import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  /// Diterima dari luar (bukan dibuat di sini) agar test bisa menyuntikkan
  /// ApiClient palsu yang memakai MockClient.
  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    // MultiProvider "menitipkan" objek ke widget tree, sehingga screen mana
    // pun bisa mengambilnya dengan context.read / context.watch.
    return MultiProvider(
      providers: [
        // ApiClient tidak pernah berubah -> Provider biasa.
        Provider<ApiClient>.value(value: apiClient),
        // AuthState berubah saat login/logout -> ChangeNotifierProvider,
        // agar widget yang memakai context.watch ikut dibangun ulang.
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState(apiClient)),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber[700],
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
