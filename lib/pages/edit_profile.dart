
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:com.xiaoyoushijie.app/widgets/dialog_widgets.dart';
import 'package:provider/provider.dart';
import '../common/app_color.dart';
import '../common/current_user.dart';
import '../common/dio_wrapper.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../models/user_model.dart';
import '../states/user_state.dart';
import '../widgets/CircularImage.dart';
import '../widgets/cache_image.dart';
import '../widgets/custom_widgets.dart';

/**
 * 编辑个人资料
 */
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()  => _EditProfileState();

}

class _EditProfileState extends State<EditProfile>{

  File? _profileBanner;
  File? _profileImage;
  late TextEditingController _screenNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _birthdayController;

  late UserState userState;

  String? selectedProvince;

  @override
  void initState() {

    userState = Provider.of<UserState>(context, listen: false);

    _screenNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _birthdayController = TextEditingController();

    _screenNameController.text = CurrentUser.instance.user!.screenName ?? '';
    _descriptionController.text = CurrentUser.instance.user!.description ?? '';
    _locationController.text = CurrentUser.instance.user!.location ?? '';
    selectedProvince = _locationController.text;
    if( CurrentUser.instance.user!.birthday != null && CurrentUser.instance.user!.birthday != '' ) {
      _birthdayController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(CurrentUser.instance.user!.birthday!));
    }

  }

  @override
  Widget build(BuildContext context) {

    userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: LatterColor.primary),
        title: Cw.customTitleText(
          S.of(context).edit_profile,
        ),
        actions: <Widget>[
          InkWell(
            onTap: () { _save(context); },
            child: Center(
              child: Text(
                S.of(context).save,
                style: TextStyle(
                  color: LatterColor.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );

  }

  Widget _body() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 230,
          child: Stack(
            children: <Widget>[
              _bannerImage(context, userState),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(userState),
              ),
            ],
          ),
        ),
        _entry(S.of(context).name, controller: _screenNameController),
        _entry(S.of(context).intro, controller: _descriptionController),
        _location(S.of(context).location, controller: _locationController),
        _dateEntry(S.of(context).date_of_birth, controller: _birthdayController)
      ],
    );
  }

  Widget _bannerImage(BuildContext context, UserState userState) {
    return Container(
      height: 180,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _profileBanner != null
                ? Image.file(_profileBanner!, fit: BoxFit.fill, width: MediaQuery.of(context).size.width, height: 180,)
                : CacheImage(path: CurrentUser.instance.user!.profileBannerUrl ?? '', fit: BoxFit.fill),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: () async {
                      bool result = await DialogPermission(context);
                      if( result ) {
                        selectBannerImage();
                      }
                    },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userImage(UserState userState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(CurrentUser.instance.user!.profileImageUrl),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: (_profileImage != null
            ? FileImage(_profileImage!)
            : customAdvanceNetworkImage(CurrentUser.instance.user!.profileImageUrl))
        as ImageProvider,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: () async {
                bool result = await DialogPermission(context);
                if( result ) {
                  selectProfileImage();
                }
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateEntry(String title,
      {required TextEditingController controller,
        int maxLine = 1,
        bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          TextField(
            controller: controller,
            readOnly: true,
            maxLines: maxLine,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
            onTap: () => showCalender(),
          )
        ],
      ),
    );
  }

  Widget _entry(String title,
      {required TextEditingController controller,
        int maxLine = 1,
        bool enabled = true}) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customText(title, style: const TextStyle(color: Colors.black54)),
              TextField(
                enabled: enabled,
                controller: controller,
                maxLines: maxLine,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                ),
              )
            ],
          ),
        );
  }

  Widget _location(String title,
      {required TextEditingController controller,
        int maxLine = 1,
        bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          InkWell(
            onTap: () => _showProvincePicker(context),
            child: InputDecorator(
              decoration: InputDecoration(
                //labelText: '省份',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: LatterColor.primary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(selectedProvince ?? S.of(context).select_location),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showProvincePicker(BuildContext context) async {

    final List<String> provinces = [
      '北京',
      '天津',
      '河北',
      '山西',
      '内蒙古',
      '辽宁',
      '吉林',
      '黑龙江',
      '上海',
      '江苏',
      '浙江',
      '安徽',
      '福建',
      '江西',
      '山东',
      '河南',
      '湖北',
      '湖南',
      '广东',
      '广西',
      '海南',
      '重庆',
      '四川',
      '贵州',
      '云南',
      '西藏',
      '陕西',
      '甘肃',
      '青海',
      '宁夏',
      '新疆',
      '台湾',
      '香港',
      '澳门'
    ];

    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              AppBar(
                title: Text(S.of(context).select_location),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provinces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(provinces[index]),
                      onTap: () {
                        Navigator.pop(context, provinces[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedProvince = result;
        _locationController.text = result;
      });
    }
  }

  void showCalender() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1949, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    setState(() {
      if (picked != null) {
        //_birthdayController.text = Cw.getDateOfBirthday(new DateFormat("yyyy-MM-dd").format(picked).toString());
        _birthdayController.text = new DateFormat("yyyy-MM-dd").format(picked).toString();
      }
    });
  }

  // 选择头像
  Future<void> selectProfileImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 裁剪
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxHeight: 180,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle:CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
              showCropGrid: false,
              hideBottomControls: true
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if( croppedFile != null ) {
        setState(() {
          _profileImage = File(croppedFile.path!);
        });
      }

    }

  }

  // 选择Banner
  void selectBannerImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 裁剪
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxHeight: 180,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 0.40),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
              showCropGrid: false,
              hideBottomControls: true
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if( croppedFile != null ) {
        setState(() {
          _profileBanner = File(croppedFile.path!);
        });
      }

    }
  }

  void _save(BuildContext context) async {

    FormData formData = new FormData.fromMap({
      "screenName": _screenNameController.text,
      "description": _descriptionController.text,
      "location": _locationController.text,
      "birthday": _birthdayController.text,
      "profileBannerImage": _profileBanner != null ? await MultipartFile.fromFile(_profileBanner!.path!, filename: "banner.jpg") : null,
      "profileUserImage": _profileImage != null ? await MultipartFile.fromFile(_profileImage!.path!, filename: "avatar.jpg") : null
    });

    var response = await DioWrapper().dio.post("/api/user/update_profile", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {

      // 保存到UserState
      UserModel? user = UserModel.fromJson(result["data"]["user"]);
      CurrentUser.instance.setUser(user);

      Cw.showSnackBarV2(context, result["msg"]);
    } else {
      Cw.showSnackBarV2(context, result["msg"]);
    }

  }

  Future image2Base64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

}