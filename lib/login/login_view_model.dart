import 'package:expiration_date/login/social_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel {
  LoginViewModel(this._socialLogin);
  bool isLogined = false;
  kakao.User? user;

  final SocialLogin _socialLogin;
  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();
      var provider = OAuthProvider("oidc.chogigang"); //파이어베이스 연결
      OAuthToken token =
          await UserApi.instance.loginWithKakaoAccount(); //파이어베이스
      //카카오 정보를 파이어베이스로 맞게 변환
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
      FirebaseAuth.instance.signInWithCredential(credential);
      print("로그인 성공! 유저 정보는 =${user!.kakaoAccount}");
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
    print("로그아웃!");
  }
}
