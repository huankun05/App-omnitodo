import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/providers/tag_provider.dart';

// ── Design tokens ───────────────────────────────────────────
const _primary = Color(0xFF2563EB);
const _primaryLight = Color(0xFF4A8AF5);
const _onSurface = Color(0xFF1A1C1D);
const _onSurfaceVariant = Color(0xFF434655);
const _white = Color(0xFFFFFFFF);
const _surfaceContainer = Color(0xFFF3F3F6);
const _surfaceContainerHigh = Color(0xFFEFEFF2);
const _surfaceContainerHighest = Color(0xFFE8E8EC);
const _danger = Color(0xFFBA1A1A);
const _dangerLight = Color(0xFFEF5350);

TextStyle _nunito({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w800,
  Color color = _onSurface,
  double? letterSpacing,
}) {
  return GoogleFonts.nunito(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

class ManageTagsDialog extends ConsumerStatefulWidget {
  const ManageTagsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const ManageTagsDialog(),
    );
  }

  @override
  ConsumerState<ManageTagsDialog> createState() => _ManageTagsDialogState();
}

class _ManageTagsDialogState extends ConsumerState<ManageTagsDialog> {
  static const _skipDeleteKey = 'omni_skip_tag_delete_confirm';
  static const _tagColors = [
    Color(0xFF2563EB),
    Color(0xFF9D4300),
    Color(0xFF943700),
    Color(0xFF006874),
    Color(0xFF6750A4),
    Color(0xFF00696D),
    Color(0xFFBA1A1A),
    Color(0xFF386A20),
    Color(0xFFE8590C),
    Color(0xFF9C36B5),
  ];
  final _addController = TextEditingController();
  final _focusNode = FocusNode();
  bool _skipDeleteConfirm = false;
  bool _colorPanelOpen = false;
  Color _selectedAddColor = _tagColors[0];
  double _addHue = 217; // default blue hue

  @override
  void initState() {
    super.initState();
    _loadSkipDeletePref();
  }

  Future<void> _loadSkipDeletePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _skipDeleteConfirm = prefs.getBool(_skipDeleteKey) ?? false;
    });
  }

  @override
  void dispose() {
    _addController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag() {
    final name = _addController.text.trim();
    if (name.isEmpty) return;
    ref.read(tagProviderProvider.notifier).addTag(name, color: _selectedAddColor);
    _addController.clear();
    _focusNode.requestFocus();
    setState(() {
      _selectedAddColor = _tagColors[(_tagColors.indexOf(_selectedAddColor) + 1) % _tagColors.length];
    });
  }

  void _deleteTag(String tagName) {
    ref.read(tagProviderProvider.notifier).removeTag(tagName);
  }

  void _renameTag(String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: _white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _primary.withAlpha(18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_rounded, size: 16, color: _primary),
                  ),
                  const SizedBox(width: 10),
                  Text('Rename Tag', style: _nunito(fontSize: 17)),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: _surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: _nunito(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'New name...',
                    hintStyle: _nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceVariant),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) {
                    final v = controller.text.trim();
                    if (v.isNotEmpty) {
                      ref.read(tagProviderProvider.notifier).renameTag(oldName, v);
                    }
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: _surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Center(
                          child: Text('Cancel',
                              style: _nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _onSurfaceVariant)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _PrimaryButton(
                      label: 'Rename',
                      onTap: () {
                        final v = controller.text.trim();
                        if (v.isNotEmpty) {
                          ref.read(tagProviderProvider.notifier).renameTag(oldName, v);
                        }
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String tagName) {
    if (_skipDeleteConfirm) {
      _deleteTag(tagName);
      return;
    }
    bool skipNext = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: _white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + Title
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _danger.withAlpha(25),
                            _dangerLight.withAlpha(18),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          size: 18, color: _danger),
                    ),
                    const SizedBox(width: 10),
                    Text('Delete Tag', style: _nunito(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 14),
                // Description
                RichText(
                  text: TextSpan(
                    style: _nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceVariant),
                    children: [
                      const TextSpan(text: 'Delete '),
                      TextSpan(
                        text: '"$tagName"',
                        style: _nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _onSurface),
                      ),
                      const TextSpan(text: '?\nThis cannot be undone.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Don't show again checkbox
                GestureDetector(
                  onTap: () {
                    setDialogState(() {
                      skipNext = !skipNext;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: skipNext ? _primary : _white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: skipNext ? _primary : _surfaceContainerHighest,
                            width: 1.5,
                          ),
                        ),
                        child: skipNext
                            ? const Icon(Icons.check_rounded,
                                size: 14, color: _white)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '不再提示，直接删除',
                          style: _nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Center(
                            child: Text('Cancel',
                                style: _nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _onSurfaceVariant)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _DangerButton(
                        label: 'Delete',
                        onTap: () async {
                          if (skipNext) {
                            final prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool(_skipDeleteKey, true);
                            if (!mounted) return;
                            setState(() {
                              _skipDeleteConfirm = true;
                            });
                          }
                          _deleteTag(tagName);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickColor(String tagName, Color currentColor) {
    const colors = [
      Color(0xFF2563EB),
      Color(0xFF9D4300),
      Color(0xFF943700),
      Color(0xFF006874),
      Color(0xFF6750A4),
      Color(0xFF00696D),
      Color(0xFFBA1A1A),
      Color(0xFF386A20),
      Color(0xFFE8590C),
      Color(0xFF9C36B5),
    ];
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: _white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.palette_rounded, size: 16, color: currentColor),
                  ),
                  const SizedBox(width: 10),
                  Text('Pick Color', style: _nunito(fontSize: 17)),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: colors.map((c) {
                  final isSelected = c.toARGB32() == currentColor.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(tagProviderProvider.notifier)
                          .updateTagColor(tagName, c);
                      Navigator.pop(ctx);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? Border.all(color: _white, width: 3)
                            : null,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: c.withAlpha(90),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          else
                            BoxShadow(
                              color: c.withAlpha(30),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded,
                              size: 18, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                    decoration: BoxDecoration(
                      color: _surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text('Cancel',
                        style: _nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _onSurfaceVariant)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagProv = ref.watch(tagProviderProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 600 ? 460.0 : screenWidth * 0.9;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: _white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_primary, _primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withAlpha(50),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.label_rounded,
                          size: 20, color: _white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Manage Tags', style: _nunito(fontSize: 19)),
                          const SizedBox(height: 2),
                          Text(
                            '${tagProv.allCategories.length} tags',
                            style: _nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        splashRadius: 16,
                        color: _onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Add tag input card ──
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _surfaceContainerHighest,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        // Color preview dot — tap to toggle panel
                        GestureDetector(
                          onTap: () => setState(() => _colorPanelOpen = !_colorPanelOpen),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _selectedAddColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedAddColor.withAlpha(50),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              _colorPanelOpen ? Icons.close_rounded : Icons.palette_rounded,
                              size: 14,
                              color: _white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _addController,
                            focusNode: _focusNode,
                            style: _nunito(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: 'Add a new tag...',
                              hintStyle: _nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _onSurfaceVariant.withAlpha(150),
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              isDense: true,
                            ),
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _addTag,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [_primary, _primaryLight],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _primary.withAlpha(60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add_rounded,
                                size: 20, color: _white),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    // ── Inline color picker panel ──
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Base color presets
                            Row(
                              children: [
                                for (final c in _tagColors)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        final hsl = HSLColor.fromColor(c);
                                        setState(() {
                                          _selectedAddColor = c;
                                          _addHue = hsl.hue;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: c,
                                          borderRadius: BorderRadius.circular(7),
                                          border: Border.all(
                                            color: _selectedAddColor.toARGB32() == c.toARGB32()
                                                ? _white
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: c.withAlpha(
                                                  _selectedAddColor.toARGB32() == c.toARGB32() ? 70 : 25),
                                              blurRadius: _selectedAddColor.toARGB32() == c.toARGB32() ? 6 : 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Row 2: Hue slider
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final hueColor = HSLColor.fromAHSL(1, _addHue, 1, 0.5).toColor();
                                return Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: hueColor,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: hueColor.withAlpha(60),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          // Hue gradient track
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Container(
                                              height: 12,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                gradient: LinearGradient(
                                                  colors: List.generate(
                                                    36,
                                                    (i) => HSLColor.fromAHSL(1, i * 10.0, 1, 0.5).toColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Transparent slider on top
                                          SliderTheme(
                                            data: SliderThemeData(
                                              trackHeight: 12,
                                              thumbShape: const RoundSliderThumbShape(
                                                  enabledThumbRadius: 8),
                                              overlayShape: const RoundSliderOverlayShape(
                                                  overlayRadius: 14),
                                              activeTrackColor: Colors.transparent,
                                              inactiveTrackColor: Colors.transparent,
                                            ),
                                            child: Slider(
                                              value: _addHue,
                                              min: 0,
                                              max: 360,
                                              onChanged: (v) {
                                                setState(() {
                                                  _addHue = v;
                                                  _selectedAddColor = HSLColor.fromAHSL(1, v, 0.7, 0.55).toColor();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _colorPanelOpen
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Tag list ──
              if (tagProv.allCategories.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.label_off_rounded,
                            size: 24, color: _onSurfaceVariant.withAlpha(120)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No tags yet',
                        style: _nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type a name above to create one',
                        style: _nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _onSurfaceVariant.withAlpha(140)),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _surfaceContainer.withAlpha(80),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      itemCount: tagProv.allCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                      itemBuilder: (_, index) {
                        final tag = tagProv.allCategories[index];
                        final isVisible =
                            !tagProv.hiddenNames.contains(tag.name);
                        final tagColor = TagProvider.parseHexColor(tag.color);
                        final isBuiltin = tag.id == '__builtin_today__';
                        return _TagTile(
                          tagName: tag.name,
                          tagColor: tagColor,
                          isVisible: isVisible,
                          isBuiltin: isBuiltin,
                          onColorTap: isBuiltin ? () {} : () => _pickColor(tag.name, tagColor),
                          onTitleTap: () => _renameTag(tag.name),
                          onDeleteTap: () => _confirmDelete(tag.name),
                          onVisibilityChanged: () =>
                              ref.read(tagProviderProvider.notifier).toggleVisibility(tag.name),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Done button ──
              SizedBox(
                width: double.infinity,
                child: _PrimaryButton(
                  label: 'Done',
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tag Tile ──────────────────────────────────────────────────

class _TagTile extends StatelessWidget {
  final String tagName;
  final Color tagColor;
  final bool isVisible;
  final bool isBuiltin;
  final VoidCallback onColorTap;
  final VoidCallback onTitleTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onVisibilityChanged;

  const _TagTile({
    required this.tagName,
    required this.tagColor,
    required this.isVisible,
    this.isBuiltin = false,
    required this.onColorTap,
    required this.onTitleTap,
    required this.onDeleteTap,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isVisible
              ? tagColor.withAlpha(35)
              : _surfaceContainerHighest,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _onSurface.withAlpha(isVisible ? 6 : 3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Color dot — tap to pick color
          GestureDetector(
            onTap: onColorTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isVisible
                    ? tagColor.withAlpha(25)
                    : _surfaceContainerHighest.withAlpha(100),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isVisible
                      ? tagColor.withAlpha(50)
                      : _surfaceContainerHighest,
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.label_rounded,
                size: 16,
                color: isVisible ? tagColor : _onSurfaceVariant.withAlpha(140),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tag name
          Expanded(
            child: GestureDetector(
              onTap: isBuiltin ? null : onTitleTap,
              child: Text(
                tagName,
                style: _nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isVisible ? _onSurface : _onSurfaceVariant.withAlpha(160),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Delete (hidden for built-in tags)
          if (!isBuiltin)
            GestureDetector(
              onTap: onDeleteTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _dangerLight.withAlpha(12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    size: 15, color: _danger),
              ),
            ),
          if (!isBuiltin) const SizedBox(width: 6),
          // Visibility toggle (hidden for built-in tags)
          if (!isBuiltin)
            GestureDetector(
              onTap: onVisibilityChanged,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: isVisible ? tagColor : _surfaceContainerHighest,
                  boxShadow: [
                    if (isVisible)
                      BoxShadow(
                        color: tagColor.withAlpha(40),
                        blurRadius: 4,
                      ),
                  ],
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment:
                      isVisible ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _white,
                      boxShadow: [
                        BoxShadow(
                          color: _onSurface.withAlpha(20),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      isVisible
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      size: 11,
                      color: isVisible ? tagColor : _onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Buttons ───────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primary, _primaryLight],
          ),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: _primary.withAlpha(70),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: _nunito(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _white),
          ),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_danger, _dangerLight],
          ),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: _danger.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: _nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: _white),
          ),
        ),
      ),
    );
  }
}
