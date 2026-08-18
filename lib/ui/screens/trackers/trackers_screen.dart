import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/services/trackers.dart';

import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key, this.mangaKey});

  final String? mangaKey;

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen> {
  final _clientId = TextEditingController();
  final _token = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _clientId.dispose();
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final trackers = context.app.trackers;
    if (!_initialized) {
      _initialized = true;
      _clientId.text = context.app.settings.anilistClientId;
      _token.text = context.app.settings.anilistToken ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }

    return KPage(
      child: Column(
        children: [
          KAppBar(title: 'Trackers', onBack: () => KRoute.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSpacing.l),
              children: [
                if (widget.mangaKey != null) ...[
                  _MangaTrackSection(mangaKey: widget.mangaKey!),
                  const SizedBox(height: KSpacing.xl),
                ],
                Text('Services', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                for (final tracker in trackers.all)
                  Padding(
                    padding: const EdgeInsets.only(bottom: KSpacing.m),
                    child: _TrackerCard(tracker: tracker),
                  ),
                const SizedBox(height: KSpacing.l),
                Text('AniList credentials', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 4),
                Text('AniList requires a client id for OAuth. Register one at anilist.co/settings/developer and paste it here — the pin flow then shows an access token to paste below.', style: theme.text(KTypeStyle.caption, size: 12, color: c.inkFaint, height: 1.5)),
                const SizedBox(height: 10),
                KTextField(
                  label: 'Client id',
                  controller: _clientId,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.app.settings.anilistClientId = v.trim(),
                ),
                const SizedBox(height: 10),
                KTextField(
                  label: 'Access token',
                  controller: _token,
                  obscure: true,
                  onChanged: (v) => context.app.settings.anilistToken = v.trim().isEmpty ? null : v.trim(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerCard extends StatefulWidget {
  const _TrackerCard({required this.tracker});
  final Tracker tracker;

  @override
  State<_TrackerCard> createState() => _TrackerCardState();
}

class _TrackerCardState extends State<_TrackerCard> {

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final t = widget.tracker;
    final color = Color(t.brandColor);

    return KCard(
      corner: PanelCorner.none,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.35))),
            child: Center(
              child: Text(t.name[0], style: theme.text(KTypeStyle.label, size: 16, weight: FontWeight.w800, color: color)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.name, style: theme.text(KTypeStyle.title, size: 14.5, weight: FontWeight.w700)),
                Text(
                  t.isLoggedIn ? 'Connected' : 'Not connected',
                  style: theme.text(KTypeStyle.caption, size: 11.5, color: t.isLoggedIn ? c.accent : c.inkFaint),
                ),
              ],
            ),
          ),
          if (t.id == 'anilist' && !t.isLoggedIn)
            KButton(label: 'Log in', size: KButtonSize.sm, onTap: () async {
              try {
                await t.login();
                if (!context.mounted) return;
                KToastHost.show(context, 'Authorize in the browser, then paste your token below');
              } catch (e) {
                if (!context.mounted) return;
                KToastHost.show(context, e.toString());
              } finally {
                if (context.mounted) setState(() {});
              }
            })
          else if (t.id == 'anilist')
            KButton(label: 'Log out', variant: KButtonVariant.secondary, size: KButtonSize.sm, onTap: () async {
              await t.logout();
              setState(() {});
            })
          else if (t.isLoggedIn)
            Icon(Icons.check_circle, size: 20, color: c.accent),
        ],
      ),
    );
  }
}

/// Per-manga tracking editor — status, score, progress; writes through the
/// tracker (AniList when connected, local otherwise).
class _MangaTrackSection extends StatefulWidget {
  const _MangaTrackSection({required this.mangaKey});
  final String mangaKey;

  @override
  State<_MangaTrackSection> createState() => _MangaTrackSectionState();
}

class _MangaTrackSectionState extends State<_MangaTrackSection> {
  Manga? _manga;
  Track? _track;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repos = context.app.repos;
    final parts = widget.mangaKey.split(':');
    final manga = await repos.mangaByKey(parts[0], parts[1]);
    Track? track;
    if (manga?.id != null) {
      final tracks = await repos.tracksForManga(manga!.id!);
      track = tracks.firstOrNull;
    }
    if (mounted) {
      setState(() {
        _manga = manga;
        _track = track;
        _loading = false;
      });
    }
  }

  Future<void> _save(Track updated) async {
    final app = context.app;
    final manga = _manga;
    if (manga?.id == null) return;
    if (updated.remoteId == null && updated.trackerId != 'comicko') {
      // not linked to a remote entry yet → link via search
      final linked = await _linkRemote(updated.trackerId);
      if (linked == null) return;
      updated = updated.copyWith(remoteId: linked.remoteId, title: linked.title, totalChapters: linked.totalChapters);
    }
    await app.repos.upsertTrack(updated);
    final tracker = app.trackers.byId(updated.trackerId);
    try {
      await tracker.update(updated);
    } catch (e) {
      if (mounted) KToastHost.show(context, 'Tracker sync failed: ${e.toString().split('\n').first}');
    }
    if (mounted) {
      setState(() => _track = updated);
      KToastHost.show(context, 'Tracked on ${tracker.name}');
    }
  }

  Future<TrackResult?> _linkRemote(String trackerId) async {
    final tracker = context.app.trackers.byId(trackerId);
    if (tracker.id == 'comicko') return null;
    final controller = TextEditingController(text: _manga?.title ?? '');
    TrackResult? result;
    await showKSheet<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Find on ${tracker.name}', style: context.kTheme.text(KTypeStyle.h2, size: 16, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        KSearchField(controller: controller, onSubmitted: (_) => setState(() {})),
        const SizedBox(height: 8),
        FutureBuilder<List<TrackResult>>(
          future: tracker.search(controller.text),
          builder: (context, snap) {
            final results = snap.data ?? const [];
            if (results.isEmpty) {
              return Padding(padding: const EdgeInsets.all(14), child: Text('Search to link', style: context.kTheme.text(KTypeStyle.caption, color: context.kColors.inkFaint)));
            }
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final r in results)
                    KListTile(
                      title: r.title,
                      subtitle: r.totalChapters > 0 ? '${r.totalChapters} chapters' : null,
                      onTap: () {
                        result = r;
                        KRoute.pop(context);
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    if (_loading) {
      return const Padding(padding: EdgeInsets.all(30), child: Center(child: KProgressRing(indeterminate: true, size: 24)));
    }
    final manga = _manga;
    if (manga == null) return const SizedBox.shrink();
    final track = _track;
    final trackerId = track?.trackerId ?? 'comicko';

    const statuses = ['Reading', 'Completed', 'Planning', 'Dropped', 'Paused', 'Re-reading', 'On hold'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Track ${manga.title}', style: theme.text(KTypeStyle.h2, size: 16, weight: FontWeight.w700)),
            const Spacer(),
            if (track != null && track.trackerId != 'comicko')
              KButton(label: 'Remove link', variant: KButtonVariant.ghost, size: KButtonSize.sm, onTap: () async {
                await context.app.repos.deleteTrack(manga.id!, track.trackerId);
                setState(() => _track = null);
              }),
          ],
        ),
        const SizedBox(height: 12),
        KCard(
          corner: PanelCorner.none,
          child: Column(
            children: [
              KListTile(
                title: 'Service',
                trailing: KSegmented<String>(
                  options: const [('comicko', 'Comicko'), ('anilist', 'AniList')],
                  value: trackerId,
                  onChanged: (v) async {
                    final base = track ?? Track(mangaId: manga.id!, trackerId: v, trackedAt: DateTime.now());
                    await _save(Track(
                      mangaId: base.mangaId,
                      trackerId: v,
                      remoteId: v == 'comicko' ? null : base.remoteId,
                      title: base.title,
                      status: base.status,
                      score: base.score,
                      lastChapterRead: base.lastChapterRead,
                      totalChapters: base.totalChapters,
                      trackedAt: base.trackedAt,
                    ));
                  },
                ),
              ),
              KListTile(
                title: 'Status',
                trailing: SizedBox(
                  width: 150,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final s in statuses)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: KChip(
                              label: s,
                              compact: true,
                              selected: track?.status == s,
                              onTap: () => _save((track ?? _newTrack(manga.id!, trackerId)).copyWith(status: s)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              KListTile(
                title: 'Score',
                trailing: SizedBox(
                  width: 170,
                  child: KSlider(
                    value: track?.score ?? 0,
                    min: 0,
                    max: 10,
                    divisions: 20,
                    onChanged: (v) => _save((track ?? _newTrack(manga.id!, trackerId)).copyWith(score: v)),
                    valueLabel: (v) => v == 0 ? '—' : v.toStringAsFixed(1),
                  ),
                ),
              ),
              KListTile(
                title: 'Progress',
                subtitle: 'Chapters read',
                trailing: SizedBox(
                  width: 150,
                  child: KSlider(
                    value: track?.lastChapterRead ?? 0,
                    min: 0,
                    max: (track?.totalChapters ?? manga.totalChapters).clamp(1, 1000).toDouble(),
                    divisions: (track?.totalChapters ?? manga.totalChapters).clamp(1, 1000),
                    onChanged: (v) => _save((track ?? _newTrack(manga.id!, trackerId)).copyWith(lastChapterRead: v)),
                    valueLabel: (v) => '${v.round()}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Track _newTrack(int mangaId, String trackerId) => Track(mangaId: mangaId, trackerId: trackerId, trackedAt: DateTime.now());
}

// imports