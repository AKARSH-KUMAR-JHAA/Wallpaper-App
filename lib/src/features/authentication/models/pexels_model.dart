

class PexelsResponse {
  final int page;
  final int perPage;
  final List<Photo> photos;
  final String? nextPage;

  PexelsResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    this.nextPage,
  });

  factory PexelsResponse.fromJson(Map<String, dynamic> json) {
    return PexelsResponse(
      page: json['page'],
      perPage: json['per_page'],
      photos: List<Photo>.from(json['photos'].map((x) => Photo.fromJson(x))),
      nextPage: json['next_page'],
    );
  }
}

class Photo {
  final String id;
  final String photographer;
  final String photographerUrl;
  final String alt;
  final String avgColor;
  final Src src;

  Photo({
    required this.id,
    required this.photographer,
    required this.photographerUrl,
    required this.alt,
    required this.avgColor,
    required this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'].toString(),
      photographer: json['photographer'] ?? 'Pexels Photographer',
      photographerUrl: json['photographer_url'] ?? '',
      alt: json['alt'] ?? '',
      avgColor: json['avg_color'] ?? '#000000',
      src: Src.fromJson(json['src']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'alt': alt,
      'avg_color': avgColor,
      'src': src.toJson(),
    };
  }
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) {
    return Src(
      original: json['original'],
      large2x: json['large2x'],
      large: json['large'],
      medium: json['medium'],
      small: json['small'],
      portrait: json['portrait'],
      landscape: json['landscape'],
      tiny: json['tiny'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }
}

class PexelsVideoResponse {
  final int page;
  final int perPage;
  final List<Video> videos;
  final String? nextPage;

  PexelsVideoResponse({
    required this.page,
    required this.perPage,
    required this.videos,
    this.nextPage,
  });

  factory PexelsVideoResponse.fromJson(Map<String, dynamic> json) {
    return PexelsVideoResponse(
      page: json['page'],
      perPage: json['per_page'],
      videos: List<Video>.from(json['videos'].map((x) => Video.fromJson(x))),
      nextPage: json['next_page'],
    );
  }
}

class Video {
  final String id;
  final int width;
  final int height;
  final String url;
  final String image;
  final int duration;
  final User user;
  final List<VideoFile> videoFiles;
  final List<VideoPicture> videoPictures;

  Video({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.image,
    required this.duration,
    required this.user,
    required this.videoFiles,
    required this.videoPictures,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'].toString(),
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      videoFiles: List<VideoFile>.from(
          (json['video_files'] as List? ?? []).map((x) => VideoFile.fromJson(x))),
      videoPictures: List<VideoPicture>.from(
          (json['video_pictures'] as List? ?? []).map((x) => VideoPicture.fromJson(x))),
    );
  }
}

class User {
  final String id;
  final String name;
  final String url;

  User({
    required this.id,
    required this.name,
    required this.url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? 'Pexels User',
      url: json['url'] ?? '',
    );
  }
}

class VideoFile {
  final String id;
  final String quality;
  final String fileType;
  final int width;
  final int height;
  final String link;

  VideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    required this.width,
    required this.height,
    required this.link,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) {
    return VideoFile(
      id: json['id'].toString(),
      quality: json['quality'] ?? 'sd',
      fileType: json['file_type'] ?? 'video/mp4',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      link: json['link'] ?? '',
    );
  }
}

class VideoPicture {
  final String id;
  final String picture;
  final int nr;

  VideoPicture({
    required this.id,
    required this.picture,
    required this.nr,
  });

  factory VideoPicture.fromJson(Map<String, dynamic> json) {
    return VideoPicture(
      id: json['id'].toString(),
      picture: json['picture'] ?? '',
      nr: json['nr'] ?? 0,
    );
  }
}

class WallhavenResponse {
  final List<Photo> photos;
  final int currentPage;
  final int lastPage;

  WallhavenResponse({
    required this.photos,
    required this.currentPage,
    required this.lastPage,
  });

  factory WallhavenResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as List;
    var meta = json['meta'];
    
    List<Photo> photos = data.map((item) {
      return Photo(
        id: item['id'],
        photographer: item['category'], // Using category as photographer name for Wallhaven
        photographerUrl: item['url'],
        alt: item['id'], // Wallhaven doesn't have an 'alt' field, using ID as fallback
        avgColor: '#000000', // Default color
        src: Src(
          original: item['path'],
          large2x: item['path'], // Use path for high resolution to match Pexels
          large: item['thumbs']['large'],
          medium: item['thumbs']['small'],
          small: item['thumbs']['small'],
          portrait: item['path'],
          landscape: item['path'],
          tiny: item['thumbs']['small'],
        ),
      );
    }).toList();

    return WallhavenResponse(
      photos: photos,
      currentPage: meta['current_page'],
      lastPage: meta['last_page'],
    );
  }
}
