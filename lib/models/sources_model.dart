class Sources{
  final int id;
  final String name;
  final String link;
  final String? logoUrl;

  const Sources({
    required this.id,
    required this.name,
    required this.link,
    this.logoUrl,
  });

  factory Sources.fromJson(Map<String, dynamic> json) {
    String? rawLogo = (json['logo_url'] ?? json['logoUrl']) as String?;
    
    if (rawLogo != null && rawLogo.startsWith('//')) {
      rawLogo = 'https:$rawLogo';
    }

    if (rawLogo != null) {
      final encodedUrl = Uri.encodeComponent(rawLogo);
      rawLogo = 'http://localhost:3000/api/watchmode/image-proxy?url=$encodedUrl';
    }


    return Sources(
      id: json['id'] as int,
      name: json['name'] as String,
      link: json['link'] as String,
       logoUrl: rawLogo,
    );
  }
}