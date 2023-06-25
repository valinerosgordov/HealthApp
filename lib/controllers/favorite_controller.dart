import 'package:get/get.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/domain/data/partner_data.dart';
import 'package:health_app/domain/repositories/favorite_repository.dart';
class FavoriteController extends GetxController{
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  final UserController _userController = Get.find();
  Rxn<List<PartnerData>> favoriteList = Rxn<List<PartnerData>>();

  getFavoriteList()async{
    favoriteList.value = await _favoriteRepository.getPartnerListStream(
        likes: _userController.user.value!.partnersLikes);
  }



  listenFavoriteStream(){
    _userController.user.listen((event) async {
      if(event != null) {
        favoriteList.value = await _favoriteRepository.getPartnerListStream(
            likes: event.partnersLikes);
      }
      });
  }

  @override
  void onReady() async{
    super.onReady();
  }

}