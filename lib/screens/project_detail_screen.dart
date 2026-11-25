import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/widgets/detail_row.dart';

/// Detail satu proyek. Datanya dikirim dari daftar lewat konstruktor,
/// jadi halaman ini tidak perlu memanggil API lagi.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (project.isFeatured)
                      Chip(
                        avatar: Icon(Icons.star, color: Colors.amber[700]),
                        label: const Text('Proyek unggulan'),
                      ),
                    DetailRow(label: 'Judul', value: project.title),
                    DetailRow(label: 'Deskripsi', value: project.description),
                    DetailRow(label: 'Tech stack', value: project.techStack),
                    DetailRow(label: 'Tahun', value: '${project.year}'),
                    // Model Django-ku tidak punya field gambar, jadi yang
                    // opsional di sini adalah URL repositori: hanya
                    // ditampilkan jika tidak kosong.
                    if (project.repoUrl.isNotEmpty)
                      DetailRow(label: 'Repositori', value: project.repoUrl),
                    DetailRow(
                      label: 'Jumlah star',
                      value: '${project.starCount}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
