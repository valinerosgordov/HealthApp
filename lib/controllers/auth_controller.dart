import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/auth/code_screen.dart';
import '../domain/repositories/auth_repository.dart';

class AuthController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxnBool userIsAuth = RxnBool();
  RxBool forgotPassLoading = false.obs;
  RxBool authLoading = false.obs;
  final AuthRepository _authRepository = AuthRepository();
  late AuthCredential phoneCredential;
  late String phoneVerificationId;
  RxInt time = RxInt(30);


  setTime()async{

    if(time.value <=30 && time.value !=0){
      time.value = time.value-1;
      await Future.delayed(Duration(seconds: 1));
      setTime();
    }else{
      await Future.delayed(Duration(seconds: 1));
      time.value = 30;
    }
  }

  //final UserController _userController = Get.find();

  User? getAuthInstance(){
    return _auth.currentUser;
  }
  isUserAuth(){
    _auth.userChanges().listen((event) {
      if(event != null){
        print(event);
        print(event.emailVerified);
        print(event.providerData);
          userIsAuth.value = true;
      }else{
        userIsAuth.value = false;
      }
    });
  }

  logOut()async{
   await _auth.signOut();
  }

  checkPhoneData({required String phoneNumber}){
    return GetUtils.isPhoneNumber(phoneNumber) && !phoneNumber.contains(' ') &&
        (phoneNumber.length > 10  || phoneNumber.length < 13);

  }

  phoneAuth(String phoneNumber) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential authCredential){
          phoneCredential = authCredential;

        },
        verificationFailed: (FirebaseException e){

        },
        codeSent: (String verificationId, [int? forceResendingToken] ){
          phoneVerificationId = verificationId;
        },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );

    time.value = 30;
    //await Future.delayed(Duration(seconds: 1));
    setTime();
  }

  Future<CodeState> sendCode({required String smsCode})async{

    try{
      PhoneAuthCredential _credential = await PhoneAuthProvider.credential(verificationId: phoneVerificationId,
          smsCode: smsCode);
      await _auth.signInWithCredential(_credential);
      return CodeOkState();
    }catch(e){
      return CodeErrorState(error:e.toString());
    }

  }

  checkSmsCode(String code){

  }







  @override
  void onReady() {
    isUserAuth();
    super.onReady();
  }
}

abstract class CodeState {

}

class CodeErrorState extends CodeState{
  final String error;
  CodeErrorState({required this.error});

}
class CodeOkState extends CodeState{}