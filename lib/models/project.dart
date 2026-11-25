import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Satu proyek portofolio, disamakan dengan `ProjectSerializer` di Django.
///
/// Kunci JSON dari DRF memakai snake_case (`tech_stack`, `repo_url`), sedangkan
/// Dart memakai camelCase (`techStack`, `repoUrl`). `FieldRename.snake`
/// menerjemahkan keduanya secara otomatis di kode hasil generasi.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.year,
    this.repoUrl = '',
    this.isFeatured = false,
    this.id,
    this.starCount = 0,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// Dibuat oleh database Django (integer), jadi tidak ikut dikirim saat POST.
  @JsonKey(includeToJson: false)
  final int? id;

  final String title;
  final String description;
  final String techStack;

  /// Wajib di model Django (`PositiveIntegerField` tanpa default).
  final int year;

  /// Opsional di Django (`blank=True`), jadi bisa kosong atau tidak dikirim.
  @JsonKey(defaultValue: '')
  final String repoUrl;

  @JsonKey(defaultValue: false)
  final bool isFeatured;

  /// Dihitung server (`SerializerMethodField`), hanya dibaca.
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
