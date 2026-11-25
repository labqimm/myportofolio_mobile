import 'package:material_ui/material_ui.dart';

/// Tampilan saat data gagal dimuat: pesan error + tombol Retry.
/// Dipakai bersama oleh daftar Project dan daftar Education.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan saat daftar kosong. Tetap dibungkus [RefreshIndicator] +
/// scroll yang selalu aktif, supaya tarik-ke-bawah (pull-to-refresh)
/// tetap bisa dipakai walaupun belum ada isinya.
class EmptyRefreshView extends StatelessWidget {
  const EmptyRefreshView({
    required this.message,
    required this.onRefresh,
    super.key,
  });

  final String message;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(child: Text(message)),
          ),
        ),
      ),
    );
  }
}
