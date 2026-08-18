import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'core/app_scope.dart';
import 'core/design/k_theme.dart';
import 'core/design/tokens.dart';
import 'ui/shell/k_app_shell.dart';
import 'ui/widgets/k_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final services = await AppServices.create();
  runApp(ComickoApp(services: services));
}

/// Root — a plain [WidgetsApp], no Material, no Scaffold, no AppBar.
/// Everything visual comes from the COMICKO design system.
class ComickoApp extends StatefulWidget {
  const ComickoApp({super.key, required this.services});

  final AppServices services;

  @override
  State<ComickoApp> createState() => _ComickoAppState();
}

class _ComickoAppState extends State<ComickoApp> {
  @override
  void initState() {
    super.initState();
    widget.services.updates.start();
  }

  @override
  void dispose() {
    widget.services.updates.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services;
    return ValueListenableBuilder<KTheme>(
    valueListenable: services.theme,
    builder: (context, theme, _) => KThemeScope(
      theme: theme,
      child: AppScope(
        scope: services,
        child: WidgetsApp(
          color: theme.colors.bg,
          debugShowCheckedModeBanner: false,
          shortcuts: const {},
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(textScaler: media.textScaler.clamp(maxScaleFactor: 1.35)),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: DefaultTextStyle(
                  style: theme.text(KTypeStyle.body),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
          onGenerateRoute: (settings) => KRoute<void>(
            page: const KAppShell(),
            kind: KRouteKind.fade,
            duration: const Duration(milliseconds: 420),
          ),
          ),
        ),
      ),
    );
  }
}
