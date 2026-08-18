import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/tokens.dart';

/// Text input built directly on [EditableText] with a fully custom
/// decoration and context menu (no Material TextField).
import 'package:flutter/material.dart' show Icons, Colors;
class KTextField extends StatefulWidget {
  const KTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.onTapOutside,
    this.error,
    this.fontSize = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool enabled;
  final bool autofocus;
  final VoidCallback? onTapOutside;
  final String? error;
  final double fontSize;
  final EdgeInsets padding;

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _obscured = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
    _focusNode.addListener(() => setState(() {}));
    if (widget.controller != null) {
      widget.controller!.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final focused = _focusNode.hasFocus;

    final box = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.enabled ? c.surface : c.surfaceAlt,
        borderRadius: BorderRadius.circular(KRadius.m),
        border: Border.all(
          color: widget.error != null
              ? const Color(0xFFE5484D)
              : focused
                  ? c.accent.withValues(alpha: 0.75)
                  : c.lineStrong,
          width: focused ? 1.4 : 1,
        ),
        boxShadow: focused ? KShadow.glow(c.accent, strength: 0.10) : null,
      ),
      child: Row(
        children: [
          if (widget.prefix != null) ...[
            IconTheme(data: IconThemeData(color: focused ? c.accent : c.inkFaint, size: 18), child: widget.prefix!),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: EditableText(
              controller: _controller,
              focusNode: _focusNode,
              style: theme.text(KTypeStyle.body, color: widget.enabled ? c.ink : c.inkFaint, size: widget.fontSize, height: 1.3),
              cursorColor: c.accent,
              backgroundCursorColor: c.inkFaint,
              selectionColor: c.accentSoft,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              obscureText: _obscured,
              maxLines: widget.maxLines,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTapOutside: (_) {
                widget.onTapOutside?.call();
                _focusNode.unfocus();
              },
              contextMenuBuilder: (context, editableTextState) => _KContextMenu(editableTextState: editableTextState),
            ),
          ),
          if (widget.obscure)
            KTextAction(
              onTap: () => setState(() => _obscured = !_obscured),
              child: Icon(_obscured ? Icons.visibility_off : Icons.visibility, size: 17),
            ),
          if (widget.suffix != null) ...[const SizedBox(width: 8), widget.suffix!],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: theme.text(KTypeStyle.label, color: c.inkMuted, size: 12)),
          const SizedBox(height: 6),
        ],
        box,
        if (widget.error != null) ...[
          const SizedBox(height: 5),
          Text(widget.error!, style: theme.text(KTypeStyle.caption, color: const Color(0xFFE5484D))),
        ],
      ],
    );
  }
}

/// Small tappable text/icon inside fields.
class KTextAction extends StatelessWidget {
  const KTextAction({super.key, required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconTheme(data: IconThemeData(color: context.kColors.inkFaint), child: child),
      ),
    );
  }
}

/// Custom context menu (copy/paste/select all) — no Material.
class _KContextMenu extends StatelessWidget {
  const _KContextMenu({required this.editableTextState});
  final EditableTextState editableTextState;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final t = context.kTheme;
    final items = <(String, VoidCallback)>[
      ('Copy', () => editableTextState.copySelection(SelectionChangedCause.toolbar)),
      ('Paste', () => editableTextState.pasteText(SelectionChangedCause.toolbar)),
      ('Select all', () => editableTextState.selectAll(SelectionChangedCause.toolbar)),
    ];
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.lineStrong),
          boxShadow: KShadow.float(Colors.black),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (label, action) in items)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  action();
                  editableTextState.hideToolbar();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Text(label, style: t.text(KTypeStyle.bodyMuted, size: 13, weight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Search field: KTextField with a magnifier + clear button.
class KSearchField extends StatelessWidget {
  const KSearchField({
    super.key,
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return KTextField(
      controller: controller,
      focusNode: focusNode,
      hint: hint,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefix: const Icon(Icons.search),
      suffix: controller == null
          ? null
          : ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller!,
              builder: (context, v, _) => v.text.isEmpty
                  ? const SizedBox.shrink()
                  : KTextAction(
                      onTap: () {
                        controller!.clear();
                        onChanged?.call('');
                      },
                      child: const Icon(Icons.close, size: 17),
                    ),
            ),
    );
  }
}

// icons import
