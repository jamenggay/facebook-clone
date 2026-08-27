import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/widgets/custom_buttom.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/shared_preference.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SessionService _session = SessionService();
  final PostService _postService = PostService();

  User? _user;
  List<Post> _posts = [];
  bool _isLoadingPosts = true;
  String _postsError = '';

  final String _coverImage = 'assets/images/coverphoto.jpg';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await _session.getUser();
    if (!mounted) return;
    setState(() => _user = user);

    if (user == null) {
      setState(() {
        _isLoadingPosts = false;
        _postsError = 'No signed-in user found.';
      });
      return;
    }

    await _loadPosts(user.id);
  }

  Future<void> _loadPosts(int userId) async {
    setState(() {
      _isLoadingPosts = true;
      _postsError = '';
    });

    try {
      final posts = await _postService.getPostsByUserId(userId);
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _isLoadingPosts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPosts = false;
        _postsError = 'Could not load the posts. Please try again.';
      });
    }
  }

  String get _userName => _user == null ? '' : _user!.fullName;

  String get _profileImage => (_user == null || _user!.image.isEmpty)
      ? 'assets/images/userprofile.jpg'
      : _user!.image;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: FB_SURFACE,
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
                    child: Image.asset(
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
                          backgroundColor: FB_SECONDARY,
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
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: FB_TEXT_PRIMARY,
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
                      color: FB_TEXT_PRIMARY,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(2)),
                    CustomFont(
                      text: _user == null ? '' : '@${_user!.username}',
                      fontSize: ScreenUtil().setSp(14),
                      color: Colors.grey,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Row(
                      children: [
                        CustomFont(
                          text: '${_posts.length}',
                          fontSize: ScreenUtil().setSp(15),
                          color: FB_TEXT_PRIMARY,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        CustomFont(
                          text: 'posts',
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
                          text: _user == null ? '' : 'ID ${_user!.id}',
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
                      color: FB_TEXT_PRIMARY,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                      color: FB_TEXT_PRIMARY,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                      color: FB_TEXT_PRIMARY,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(2000),
                child: TabBarView(
                  children: [
                    _buildPostsTab(),
                    _buildAboutTab(),
                    _buildPhotosTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_isLoadingPosts) {
      return Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
        child: Center(
          child: CircularProgressIndicator(color: FB_LIGHT_PRIMARY),
        ),
      );
    }

    if (_postsError != '') {
      return Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: Column(
          children: [
            CustomFont(
              text: _postsError,
              fontSize: ScreenUtil().setSp(14),
              color: FB_TEXT_COLOR_GREY,
            ),
            if (_user != null)
              TextButton(
                onPressed: () => _loadPosts(_user!.id),
                child: CustomFont(
                  text: 'Retry',
                  fontSize: ScreenUtil().setSp(14),
                  color: FB_DARK_PRIMARY,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: CustomFont(
          text: 'This user has not posted anything yet.',
          fontSize: ScreenUtil().setSp(14),
          color: FB_TEXT_COLOR_GREY,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostCard(
          postId: post.id,
          postTitle: post.title,
          userName: _userName,
          postContent: post.body,
          likesCount: post.likes.toString(),
          sharesCount: 0,
          date: DateTime.now().subtract(Duration(days: index + 1)),
          userImage: _profileImage,
          currentUserImage: _profileImage,
        );
      },
    );
  }

  Widget _buildAboutTab() {
    if (_user == null) return const SizedBox();
    final user = _user!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenUtil().setHeight(10)),
            Text(
              'Description',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.bold,
                color: FB_TEXT_PRIMARY,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            Text(
              '${user.fullName} is a ${user.jobTitle.isEmpty ? "member" : user.jobTitle} '
              '${user.company.isEmpty ? "" : "at ${user.company}"}. '
              'This profile is loaded from the DummyJSON users endpoint and '
              'saved on this device with shared_preferences.',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(17),
                color: FB_TEXT_PRIMARY,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text(
              'Details',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.bold,
                color: FB_TEXT_PRIMARY,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildDetailRow(
              Icons.house,
              user.city.isEmpty
                  ? 'No address on file'
                  : 'Lives in ${user.city}, ${user.country}',
            ),
            _buildDetailRow(
              Icons.work,
              user.company.isEmpty
                  ? 'No workplace on file'
                  : 'Works at ${user.company}',
            ),
            _buildDetailRow(
              Icons.school,
              user.university.isEmpty
                  ? 'No school on file'
                  : 'Studies at ${user.university}',
            ),
            _buildDetailRow(
              Icons.email,
              user.email.isEmpty ? 'No email on file' : user.email,
            ),
            _buildDetailRow(
              Icons.phone,
              user.phone.isEmpty ? 'No phone on file' : user.phone,
            ),
            _buildDetailRow(
              Icons.cake,
              user.age == 0 ? 'No age on file' : '${user.age} years old',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(6)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: ScreenUtil().setSp(17)),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(17),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    return GridView.count(
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
    );
  }

  Widget _buildPhotoItem(String imagePath) {
    return Container(
      color: Colors.grey[400],
      child: Image(image: AssetImage(imagePath), fit: BoxFit.cover),
    );
  }
}
