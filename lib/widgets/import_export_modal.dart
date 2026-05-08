import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../services/local_db_service.dart';

class ImportExportModal extends StatefulWidget {
  const ImportExportModal({super.key});

  @override
  State<ImportExportModal> createState() => _ImportExportModalState();
}

class _ImportExportModalState extends State<ImportExportModal> {
  bool _isLoading = false;

  Future<void> _handleExport() async {
    setState(() => _isLoading = true);
    try {
      await LocalDbService().exportDatabase();
      if (mounted) Navigator.pop(context);
      // TODO: notif of export successful
    } catch (e) {
      // TODO: notif of export failed
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleImport() async {
    setState(() => _isLoading = true);
    try {
      await LocalDbService().importDatabase();
      if (mounted) Navigator.pop(context);
      // TODO: notif of import successful
    } catch (e) {
      // TODO: notif of import failed
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.plannerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data Management', style: AppStyles.heading(size: 18)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: AppColors.softPeriwinkle),
              ))
            else ...[
              _ActionButton(
                icon: Icons.ios_share_rounded,
                title: 'Export Backup',
                subtitle: 'Save a .json copy of your data',
                onTap: _handleExport,
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.file_download_outlined,
                title: 'Import Backup',
                subtitle: 'Restore from a previous backup',
                onTap: _handleImport,
                isDanger: true,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionButton({required this.icon, required this.title, required this.subtitle, required this.onTap, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.plannerSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDanger ? Colors.redAccent.withOpacity(0.3) : AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? Colors.redAccent : AppColors.softPeriwinkle, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.heading(size: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppStyles.body(size: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}