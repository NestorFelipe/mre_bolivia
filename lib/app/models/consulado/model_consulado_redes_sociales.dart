class RedSocial {
  final String url;

  RedSocial({
    required this.url,
  });

  factory RedSocial.fromJson(Map<String, dynamic> json) {
    return RedSocial(
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

