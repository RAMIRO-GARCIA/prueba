class UrlImage {
    final String message;
    final String url;

    UrlImage({
        required this.message,
        required this.url,
    });

    factory UrlImage.fromJson(Map<String, dynamic> json) => UrlImage(
        message: json["message"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "url": url,
    };
}
