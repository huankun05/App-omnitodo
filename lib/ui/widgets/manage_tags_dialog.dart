import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/tag_provider.dart';

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
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addTag() {
    final name = _addController.text.trim();
    if (name.isEmpty) return;
    ref.read(tagProviderProvider.notifier).addTag(name);
    _addController.clear();
  }

  void _renameTag(String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tag name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(tagProviderProvider.notifier).renameTag(oldName, newName);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _pickColor(String tagName, Color currentColor) {
    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF9D4300),
      const Color(0xFF943700),
      const Color(0xFF006874),
      const Color(0xFF6750A4),
      const Color(0xFF00696D),
      const Color(0xFFBA1A1A),
      const Color(0xFF386A20),
      const Color(0xFFE8590C),
      const Color(0xFF9C36B5),
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick Color'),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((c) {
            final isSelected = c.toARGB32() == currentColor.toARGB32();
            return GestureDetector(
              onTap: () {
                ref.read(tagProviderProvider.notifier).updateTagColor(tagName, c);
                Navigator.pop(ctx);
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: c.withAlpha(100), blurRadius: 8)]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagProv = ref.watch(tagProviderProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 600 ? 420.0 : screenWidth * 0.85;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.label_outline,
                      size: 22, color: Color(0xFF2563EB)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Manage Tags',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Add tag input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'New tag name...',
                        hintStyle: const TextStyle(
                            fontSize: 14, color: Color(0xFFC3C6D7)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide:
                              const BorderSide(color: Color(0xFFC3C6D7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide:
                              const BorderSide(color: Color(0xFFC3C6D7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide:
                              const BorderSide(color: Color(0xFF2563EB)),
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(9999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9999),
                      onTap: _addTag,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child:
                            Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tag list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tagProv.allCategories.length,
                  itemBuilder: (_, index) {
                    final tag = tagProv.allCategories[index];
                    final isVisible = !tagProv.hiddenNames.contains(tag.name);
                    final tagColor = TagProvider.parseHexColor(tag.color);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isVisible
                            ? tagColor.withAlpha(18)
                            : const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        leading: GestureDetector(
                          onTap: () => _pickColor(tag.name, tagColor),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isVisible
                                  ? tagColor.withAlpha(30)
                                  : const Color(0xFFC3C6D7).withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.label_rounded,
                              size: 16,
                              color: isVisible
                                  ? tagColor
                                  : const Color(0xFF737686),
                            ),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () => _renameTag(tag.name),
                          child: Text(
                            tag.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isVisible
                                  ? const Color(0xFF1A1C1D)
                                  : const Color(0xFF737686),
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 18, color: Color(0xFFBA1A1A)),
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                tagProv.removeTag(tag.name);
                              },
                            ),
                            Switch(
                              value: isVisible,
                              onChanged: (_) => tagProv.toggleVisibility(tag.name),
                              activeThumbColor: tagColor,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Done',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
