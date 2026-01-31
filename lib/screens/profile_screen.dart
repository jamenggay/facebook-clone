import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/widgets/custom_buttom.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';
import 'package:tuazon_mobprog/services/user_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDatabase _userDatabase = UserDatabase();
  String _userName = 'Jamaine Tuazon'; // Default name
  String _coverImage = 'assets/images/coverphoto.jpg';
  String _profileImage = 'assets/images/userprofile.jpg';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Get the logged-in username from database file
      final username = await _userDatabase.getCurrentUser();

      if (username != null && username.isNotEmpty) {
        // Fetch user data from database
        final user = await _userDatabase.findUserByUsername(username);

        if (user != null && mounted) {
          final firstName = user['firstName']?.toString() ?? '';
          final lastName = user['lastName']?.toString() ?? '';
          final fullName = '$firstName $lastName'.trim();

          if (fullName.isNotEmpty && mounted) {
            setState(() {
              _userName = fullName;
            });
          }
        }
      }
    } catch (e) {
      // If error occurs, keep default name
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: _coverImage.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: _coverImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(Icons.error),
                            ),
                          )
                        : Image.asset(
                            _coverImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: ScreenUtil().setWidth(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage.startsWith('http')
                              ? CachedNetworkImageProvider(_profileImage)
                              : AssetImage(_profileImage) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: _userName,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(20),
                      color: Colors.black,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Row(
                      children: [
                        CustomFont(
                          text: '248',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'followers',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        Icon(
                          Icons.circle,
                          size: ScreenUtil().setSp(5),
                          color: Colors.grey,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        CustomFont(
                          text: '486',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'following',
                          fontSize: ScreenUtil().setSp(15),
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Row(
                      children: [
                        CustomButton(
                          buttonName: 'Edit Profile',
                          onPressed: () {},
                          buttonType: 'outlined',
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomButton(
                          buttonName: 'Share Profile',
                          onPressed: () {},
                          buttonType: 'outlined',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              TabBar(
                indicatorColor: FB_DARK_PRIMARY,
                tabs: [
                  Tab(
                    child: CustomFont(
                      text: 'Posts',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(2000),
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        PostCard(
                          userName: _userName,
                          postContent: 'CCIT Domination at ISPE Games 2025!',
                          likesCount: "19",
                          commentsCount: 4,
                          sharesCount: 9,
                          imagePath: 'assets/images/wallpost1.jpg',
                          showPlaceholder: false,
                          date: DateTime.now().subtract(Duration(days: 1)),
                          userImage: 'assets/images/userprofile.jpg',
                        ),
                        PostCard(
                          userName: _userName,
                          postContent:
                              'pasensya na sa mga inaanak q, capstone muna',
                          likesCount: "21",
                          commentsCount: 2,
                          sharesCount: 5,
                          imagePath: 'assets/images/wallpost2.jpg',
                          showPlaceholder: false,
                          date: DateTime.now().subtract(Duration(days: 2)),
                          userImage: 'assets/images/userprofile.jpg',
                        ),
                        PostCard(
                          userName: _userName,
                          postContent: 'na para bang non-existent and weekend',
                          likesCount: "321",
                          commentsCount: 12,
                          sharesCount: 3,
                          date: DateTime.now().subtract(Duration(days: 3)),
                          userImage: 'assets/images/userprofile.jpg',
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(10),
                            top: ScreenUtil().setWidth(10),
                            bottom: ScreenUtil().setWidth(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setHeight(10)),
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "is a 3rd year BSIT-MWA at National University. She is Aspiring IT professional with interests in systems, security, and application development. Values teamwork, discipline, and continuous improvement while building practical and technical skills.",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(17),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setHeight(10)),
                              Text(
                                "Details",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: ScreenUtil().setHeight(10)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.house,
                                    color: Colors.grey,
                                    size: ScreenUtil().setSp(17),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    "Lives at Caloocan City",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.work,
                                    color: Colors.grey,
                                    size: ScreenUtil().setSp(17),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    "Works at Krusty Crub",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Colors.grey,
                                    size: ScreenUtil().setSp(17),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    "Studies at National University",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                    size: ScreenUtil().setSp(17),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    "Single",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                      children: <Widget>[
                        _buildPhotoItem('assets/images/photos1.jpg'),
                        _buildPhotoItem('assets/images/photos2.jpg'),
                        _buildPhotoItem('assets/images/photos3.jpg'),
                        _buildPhotoItem('assets/images/photos4.jpg'),
                        _buildPhotoItem('assets/images/photos5.jpg'),
                        _buildPhotoItem('assets/images/photos6.jpg'),
                        _buildPhotoItem('assets/images/photos7.jpg'),
                        _buildPhotoItem('assets/images/coverphoto.jpg'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoItem(String imagePath) {
    return Container(
      color: Colors.grey[400],
      child: imagePath.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[400],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey[400], child: Icon(Icons.error)),
            )
          : Image(image: AssetImage(imagePath), fit: BoxFit.cover),
    );
  }
}
