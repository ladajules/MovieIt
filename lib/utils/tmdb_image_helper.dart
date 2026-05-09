class TmdbImageHelper {
  static const String _baseUrl = 'https://image.tmdb.org/t/p/';

  static String buildUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return '';
    
    if (path.startsWith('http')) return path;

    String cleanPath = path;
    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);
    if (cleanPath.startsWith('w500')) cleanPath = cleanPath.replaceFirst('w500', '');
    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);

    return '$_baseUrl$size/$cleanPath';
  }
}