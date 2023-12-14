import 'package:http/http.dart' as http;

class AppDependencies {
  final TransitiveDependency dependency;

  const AppDependencies({required this.dependency});
}

class TransitiveDependency {
  final http.Client httpClient;

  Future<void> request() => httpClient.get(Uri.parse('https://httpbin.org/get')).then((r) {
        print(hashCode);
      });

  TransitiveDependency({required this.httpClient});
}
