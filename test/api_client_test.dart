import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

/// Unit test ApiClient memakai MockClient: tidak ada request sungguhan ke
/// Django, kita yang menentukan balasan server untuk tiap skenario.
void main() {
  const baseUrl = 'http://test.local';

  final sampleProject = {
    'id': 7,
    'title': 'MyPortfolio',
    'description': 'Website portofolio',
    'tech_stack': 'Django',
    'year': 2026,
    'repo_url': 'https://github.com/labqimm/myportofolio',
    'is_featured': true,
    'star_count': 3,
    'is_starred': false,
    'starred_by_names': '',
  };

  group('Project model', () {
    test('fromJson memetakan snake_case ke camelCase', () {
      final project = Project.fromJson(sampleProject);
      expect(project.id, 7);
      expect(project.techStack, 'Django');
      expect(project.repoUrl, 'https://github.com/labqimm/myportofolio');
      expect(project.starCount, 3);
    });

    test('field opsional yang tidak dikirim memakai nilai default', () {
      final project = Project.fromJson({
        'id': 1,
        'title': 'A',
        'description': 'B',
        'tech_stack': 'C',
        'year': 2025,
      });
      expect(project.repoUrl, '');
      expect(project.isFeatured, isFalse);
      expect(project.starCount, 0);
    });

    test('toJson tidak mengirim field milik server', () {
      final json = Project.fromJson(sampleProject).toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('star_count'), isFalse);
      expect(json['tech_stack'], 'Django');
    });
  });

  group('ApiClient', () {
    test('getProjects mengirim GET publik tanpa Authorization', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$baseUrl/api/v1/projects/');
        expect(request.headers.containsKey('Authorization'), isFalse);
        return http.Response(jsonEncode([sampleProject]), 200);
      });
      final api = ApiClient(client: mock, baseUrl: baseUrl);

      final projects = await api.getProjects();
      expect(projects, hasLength(1));
      expect(projects.first.title, 'MyPortfolio');
    });

    test('createProject mengirim header token dan body tanpa id', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Token abc123');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body.containsKey('id'), isFalse);
        expect(body['title'], 'Baru');
        return http.Response(
          jsonEncode({...sampleProject, 'title': 'Baru'}),
          201,
        );
      });
      final api = ApiClient(client: mock, baseUrl: baseUrl);

      final created = await api.createProject(
        const Project(
          title: 'Baru',
          description: 'D',
          techStack: 'Flutter',
          year: 2026,
        ),
        token: 'abc123',
      );
      expect(created.id, 7);
    });

    test('status non-2xx dilempar sebagai ApiException', () async {
      final mock = MockClient(
        (request) async => http.Response('{"detail":"Invalid token."}', 401),
      );
      final api = ApiClient(client: mock, baseUrl: baseUrl);

      await expectLater(
        api.getProjects(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('friendlyMessage mengambil pesan validasi pertama dari DRF', () {
      const e = ApiException(400, '{"year": ["A valid integer is required."]}');
      expect(e.friendlyMessage, 'year: A valid integer is required.');
    });
  });

  group('AuthState', () {
    test('login menyimpan token, logout menghapusnya', () async {
      final mock = MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response('{"token": "abc123"}', 200);
        }
        expect(request.headers['Authorization'], 'Token abc123');
        return http.Response('', 204);
      });
      final auth = AuthState(ApiClient(client: mock, baseUrl: baseUrl));

      await auth.login('owner', 'secret');
      expect(auth.isLoggedIn, isTrue);
      expect(auth.token, 'abc123');

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });

    test('logout tetap menghapus sesi walaupun server menolak', () async {
      final mock = MockClient((request) async => http.Response('', 401));
      final auth = AuthState(
        ApiClient(client: mock, baseUrl: baseUrl),
        initialToken: 'expired',
      );

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });
  });
}
