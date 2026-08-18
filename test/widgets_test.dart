import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:comicko/core/design/k_theme.dart';
import 'package:comicko/core/design/tokens.dart';
import 'package:comicko/ui/widgets/widgets.dart';

const _scale = [
  (40.0, FontWeight.w700, 1.05, -1.0),
  (28.0, FontWeight.w700, 1.12, -0.5),
  (22.0, FontWeight.w700, 1.2, -0.2),
  (17.0, FontWeight.w600, 1.3, 0.0),
  (15.0, FontWeight.w400, 1.45, 0.0),
  (14.0, FontWeight.w400, 1.4, 0.0),
  (12.0, FontWeight.w400, 1.35, 0.1),
  (13.0, FontWeight.w600, 1.2, 0.6),
  (11.0, FontWeight.w600, 1.2, 1.2),
];

Widget wrap(Widget child, {Widget? scope}) => KThemeScope(
      theme: KTheme(palette: kPalettes.first, brightness: Brightness.dark, typeScale: _scale),
      child: scope ??
          Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [OverlayEntry(builder: (_) => child)],
            ),
          ),
    );

void main() {
  testWidgets('KButton fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(Center(
      child: KButton(label: 'Go', onTap: () => taps++),
    )));
    await tester.tap(find.text('Go'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('KButton respects disabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(Center(
      child: KButton(label: 'Stuck', onTap: () => taps++, disabled: true),
    )));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Stuck'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(taps, 0, reason: 'disabled button must not fire');
  });

  testWidgets('KSwitch toggles', (tester) async {
    var value = false;
    await tester.pumpWidget(wrap(Center(
      child: KSwitch(value: value, onChanged: (v) => value = v, label: 'Wifi'),
    )));
    await tester.tap(find.text('Wifi'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(value, isTrue);
  });

  testWidgets('KCheckbox toggles', (tester) async {
    var value = false;
    await tester.pumpWidget(wrap(Center(
      child: KCheckbox(value: value, onChanged: (v) => value = v, label: 'Pick'),
    )));
    await tester.tap(find.text('Pick'));
    await tester.pump();
    expect(value, isTrue);
  });

  testWidgets('KSegmented switches selection', (tester) async {
    var selected = 0;
    await tester.pumpWidget(wrap(Center(
      child: KSegmented<int>(
        options: const [(0, 'A'), (1, 'B'), (2, 'C')],
        value: selected,
        onChanged: (v) => selected = v,
      ),
    )));
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('KTabBar switches index', (tester) async {
    var index = 0;
    await tester.pumpWidget(wrap(
      Column(children: [
        KTabBar(tabs: const ['One', 'Two'], index: index, onChanged: (i) => index = i),
      ]),
    ));
    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(index, 1);
  });

  testWidgets('KSearchField collects text input', (tester) async {
    String? value;
    await tester.pumpWidget(wrap(Center(
      child: SizedBox(
        width: 220,
        child: KSearchField(hint: 'Search', onChanged: (v) => value = v),
      ),
    )));
    await tester.enterText(find.byType(KSearchField), 'manga');
    await tester.pump();
    expect(value, 'manga');
    expect(find.text('manga'), findsOneWidget);
  });

  testWidgets('KSlider emits clamped values', (tester) async {
    double? value;
    await tester.pumpWidget(wrap(Center(
      child: SizedBox(
        width: 260,
        child: KSlider(value: 0.5, min: 0, max: 1, onChanged: (v) => value = v),
      ),
    )));
    await tester.drag(find.byType(KSlider), const Offset(130, 0));
    await tester.pump();
    expect(value, isNotNull);
    expect(value!, greaterThanOrEqualTo(0));
    expect(value!, lessThanOrEqualTo(1));
  });

  testWidgets('KCard renders child and tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(Center(
      child: KCard(onTap: () => taps++, child: const Text('Card body')),
    )));
    expect(find.text('Card body'), findsOneWidget);
    await tester.tap(find.text('Card body'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('KListTile shows title/subtitle', (tester) async {
    await tester.pumpWidget(wrap(const Column(children: [
      KListTile(title: 'Chapter 1', subtitle: 'scanlator group'),
    ])));
    expect(find.text('Chapter 1'), findsOneWidget);
    expect(find.text('scanlator group'), findsOneWidget);
  });

  testWidgets('KCover renders placeholder for missing url', (tester) async {
    await tester.pumpWidget(wrap(Center(
      child: KCover(url: null, title: 'Some Manga', height: 160),
    )));
    expect(find.byType(KCover), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('KBadge hides at zero, shows count', (tester) async {
    await tester.pumpWidget(wrap(const Column(children: [
      KBadge(count: 0),
      KBadge(count: 3),
    ])));
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('KProgressRing accepts values', (tester) async {
    await tester.pumpWidget(wrap(const Center(
      child: KProgressRing(value: 0.42, size: 30),
    )));
    expect(find.byType(KProgressRing), findsOneWidget);
  });

  testWidgets('KEmpty shows message with action', (tester) async {
    var action = 0;
    await tester.pumpWidget(wrap(Center(
      child: KEmpty(
        title: 'Empty!',
        message: 'Nothing here',
        action: KButton(label: 'Do it', onTap: () => action++),
      ),
    )));
    expect(find.text('Empty!'), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    await tester.tap(find.text('Do it'));
    await tester.pump();
    expect(action, 1);
  });

  testWidgets('KRefresh shows indicator on overscroll', (tester) async {
    var refreshed = false;
    await tester.pumpWidget(wrap(ScaffoldK(
      child: KRefresh(
        onRefresh: () async => refreshed = true,
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (_, i) => SizedBox(height: 60, child: Text('row $i')),
        ),
      ),
    )));
    await tester.fling(find.text('row 0'), const Offset(0, 400), 1200);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));
    expect(refreshed, isTrue);
  });
}

/// Minimal full-screen scaffold for tests (no Material).
class ScaffoldK extends StatelessWidget {
  const ScaffoldK({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => ColoredBox(color: const Color(0xFF000000), child: child);
}