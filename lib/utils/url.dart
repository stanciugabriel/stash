const dev = false;

const apiURL = dev ? 'http://localhost:6000' : 'https://stash.blitzapp.ro';

const Map<String, String> basicHeader = <String, String>{
  'Content-Type': 'application/json',
};

Map<String, String> authHeader(String token) {
  return <String, String>{
    'ContentType': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

String getStoreImage(String id) {
  return '$apiURL/images/$id.png';
}
