import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<User> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount? googleSignInAccount =
  await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);
  final UserCredential authResult =
  await _auth.signInWithCredential(credential);
  User? users = (await _auth.signInWithCredential(credential)).user;
  users?.updatePassword("asem789asem");
  final User? user = authResult.user;
  final AdditionalUserInfo? additionalUserInfo = authResult.additionalUserInfo;
  print(additionalUserInfo!.profile);
  if (additionalUserInfo!.isNewUser) {
    print('New user logged in.');
  } else {
    print('Existing user logged in.');
  }
  print(user!.photoURL);
  return user!;
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url, headers: headers!..addAll(_headers));

}

