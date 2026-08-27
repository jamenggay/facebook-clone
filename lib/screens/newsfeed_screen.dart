import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/shared_preference.dart';
import '../services/user_service.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  final SessionService _session = SessionService();

  List<Post> _posts = [];
  Map<int, User> _authors = {};
  String _currentUserImage = 'assets/images/userprofile.jpg';
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final posts = await _postService.getPosts(limit: 12);
      final authors = await _userService.getAuthors();
      final me = await _session.getUser();

      if (!mounted) return;
      setState(() {
        _posts = posts;
        _authors = authors;
        if (me != null && me.image.isNotEmpty) _currentUserImage = me.image;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Could not load the newsfeed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: FB_LIGHT_PRIMARY));
    }

    if (_error != '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: ScreenUtil().setSp(40),
              color: Colors.grey,
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            CustomFont(
              text: _error,
              fontSize: ScreenUtil().setSp(14),
              color: FB_TEXT_COLOR_GREY,
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            TextButton(
              onPressed: _loadFeed,
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

    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: ListView(children: _buildFeedItems()),
    );
  }

  List<Widget> _buildFeedItems() {
    final List<Widget> items = [];

    for (int i = 0; i < _posts.length; i++) {
      final post = _posts[i];
      final author = _authors[post.userId];

      items.add(
        PostCard(
          postId: post.id,
          postTitle: post.title,
          userName: author == null ? 'Chatterly User' : author.fullName,
          postContent: post.body,
          likesCount: post.likes.toString(),
          sharesCount: 0,
          date: DateTime.now().subtract(Duration(hours: i + 1)),
          userImage: (author == null || author.image.isEmpty)
              ? 'assets/images/userprofile.jpg'
              : author.image,
          currentUserImage: _currentUserImage,
        ),
      );

      if (i % 2 == 1) items.add(buildAdvertisementCarousel());
    }

    return items;
  }

  List<Widget> carouselItems() {
    return [
      PostCard(
        userName: 'Udemy',
        postContent: 'Learn Python with this comprehensive course',
        imagePath: 'assets/images/adsImage1.png',
        date: DateTime.now(),
        adsMarket: 'Complete Boothcamp',
        userImage: 'assets/images/adsProfile1.jpg',
      ),
      PostCard(
        userName: 'AECC Global',
        postContent: 'Isang okasyon. Walang hanggang oportunidad!',
        imagePath: 'assets/images/adsImage2.png',
        date: DateTime.now(),
        adsMarket: 'Ikaw na to!',
        userImage: 'assets/images/adsProfile2.jpg',
      ),
      PostCard(
        userName: 'Uniqlo Philippines',
        postContent: 'Step into the new season with UNIQLO!',
        imagePath: 'assets/images/adsImage3.png',
        date: DateTime.now(),
        adsMarket: 'Shop Now!',
        userImage: 'assets/images/adsProfile3.jpg',
      ),
      PostCard(
        userName: 'Udemy',
        postContent: 'The Complete Full-Stack Developer Course',
        imagePath: 'assets/images/adsImage4.jpg',
        date: DateTime.now(),
        adsMarket: 'Buy Now!',
        userImage: 'assets/images/adsProfile1.jpg',
      ),
      PostCard(
        userName: 'SMU MITB',
        postContent: 'Unlock your future with an SMU MITB Scholarship!',
        imagePath: 'assets/images/adsImage5.jpg',
        date: DateTime.now(),
        adsMarket: 'Apply Now!',
        userImage: 'assets/images/adsProfile5.jpg',
      ),
      PostCard(
        userName: 'monday.com',
        postContent: 'A work platform your team will actually love!',
        imagePath: 'assets/images/adsImage6.jpg',
        date: DateTime.now(),
        adsMarket: 'Download Now!',
        userImage: 'assets/images/adsProfile6.jpg',
      ),
      PostCard(
        userName: 'ChatGPT',
        postContent: 'Ang ChatGPT Go, nasa Pilipinas na!',
        imagePath: 'assets/images/adsImage7.jpg',
        date: DateTime.now(),
        adsMarket: 'Subscribe Now!',
        userImage: 'assets/images/adsProfile7.jpg',
      ),
    ];
  }

  Widget buildAdvertisementCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(10),
            vertical: ScreenUtil().setHeight(5),
          ),
          child: CustomFont(
            text: 'Advertisement',
            fontSize: ScreenUtil().setSp(18),
            color: FB_DARK_PRIMARY,
            fontWeight: FontWeight.bold,
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 308.h,
            padEnds: false,
          ),
          items: carouselItems(),
        ),
      ],
    );
  }
}
