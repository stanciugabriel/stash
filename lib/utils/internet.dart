import 'dart:io';

Future<bool> checkInternet() async {
  try {
    await InternetAddress.lookup('stash.blitzapp.ro');
    return true;
  } on SocketException {
    return false;
  }
}
