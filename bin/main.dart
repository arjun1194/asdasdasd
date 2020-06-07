import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'models/artist.dart';

void main(List<String> arguments) {
//  getArtistImage(name: "eminem").then((res) {
//    print(res.toString());
//
//  }).catchError((err) {
//    print(err);
//  });
  getArtistDetail(artistId: 111051);
}

String imageUrl({int size = 600, String url}) {
  return url.replaceFirst('{w}', '${size}').replaceFirst('{h}', '${size}');
}

Future<ArtistImage> getArtistImage({String name, int size = 600}) async {
  var url =
      'https://amp-api.music.apple.com/v1/catalog/us/search?term=${name}&types=artists&limit=25&includeOnly=artists';
  var headers = {
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36',
    'authorization':
        'Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNTkxNDU4MjUxLCJleHAiOjE2MDcwMTAyNTF9.JfjAAoLNUkT1q3Rj3c_Wd0m7YPWO6KDNAtoEq67sgvXCmV_JpneYHQrhl8-HqaqYD10NLbrTPcMELNx4ER0cjw'
  };
  var response = await http.get(url, headers: headers);
  var jsonResponse = convert.jsonDecode(response.body);
  //print(jsonResponse['results']['artists']);
  if (jsonResponse['results']['artists'] == null) {
    return Future.error('Artist Not Found');
  }
  var artist = jsonResponse['results']['artists']['data'][0];
  var id = int.parse(artist['id']);
  var u = artist['attributes']['artwork']['url'] as String;
  var image = imageUrl(url: u);
  return Future.value(ArtistImage(id: id, image: image));
}

Future getArtistDetail({int artistId}) async {
  var queryParams =
      '?views=featured-release%2Cfull-albums%2csimilar-artists&extend=artistBio%2CbornOrFormed%2CeditorialArtwork%2Corigin&l=en-us';
  var baseUrl = 'https://amp-api.music.apple.com/v1/catalog/us/artists/';
  var url = baseUrl + artistId.toString() + queryParams;
  var headers = {
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36',
    'authorization':
        'Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNTkxNDU4MjUxLCJleHAiOjE2MDcwMTAyNTF9.JfjAAoLNUkT1q3Rj3c_Wd0m7YPWO6KDNAtoEq67sgvXCmV_JpneYHQrhl8-HqaqYD10NLbrTPcMELNx4ER0cjw'
  };
  var response = await http.get(url, headers: headers);
  var jsonResponse = convert.jsonDecode(response.body);
  if (jsonResponse['errors'] != null) {
    return Future.error(jsonResponse['errors']['detail']);
  }
  //print(ArtistAttributes.fromJson(jsonResponse['data'][0]['attributes']).toString());
  (jsonResponse['data'][0]['relationships']['albums']['data']).forEach((alb) {
    var x = AlbumAttr.fromJson(alb);
    print(x.attributes.name);
  });

  return Future.value();
}

class ArtistImage {
  int id;
  String image;

  ArtistImage({this.id, this.image});

  @override
  String toString() {
    return 'ArtistImage{id: $id, image: $image}';
  }
}

class Artist {
  int id;
  String name;
  String bio;
  String bornOrFormed;
  String image;
  List<String> genres;
  List<Album> albums;
  List<Album> essentialAlbums;
  List<SimilarArtist> similarArtist;

  Artist(
      {this.id,
      this.name,
      this.bio,
      this.bornOrFormed,
      this.image,
      this.genres,
      this.albums,
      this.essentialAlbums,
      this.similarArtist});
}

class Album {
  ///id
  /// name
  /// labelName
  /// trackCount
  /// releaseDate
  /// genre[]
  /// image
  /// contentRating
  int id;
  String name;
  String labelName;
  int trackCount;
  String releaseDate;
  List<String> genres;
  String imageUrl;
  String contentRating;

  Album(
      {this.id,
      this.name,
      this.labelName,
      this.trackCount,
      this.releaseDate,
      this.genres,
      this.imageUrl,
      this.contentRating});
}

class SimilarArtist {
  int id;
  String name;
  String image;

  SimilarArtist({this.id, this.name, this.image});
}
