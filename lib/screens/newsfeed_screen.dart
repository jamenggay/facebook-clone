import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import '../constants.dart';

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //UI
    return ListView(
      children: [
        PostCard(
          userName: 'Jamaine Tuazon',
          postContent: 'na para bang non-existent and weekend',
          likesCount: "321",
          commentsCount: 12,
          sharesCount: 3,
          date: DateTime.now().subtract(Duration(days: 1)),
          userImage: 'assets/images/userprofile.jpg',
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'NU Central Student Government',
          postContent: 'PAGEANT SLUSH PROTEST SLUSH PROWESS!',
          likesCount: "124",
          commentsCount: 8,
          sharesCount: 15,
          imagePath:
              'https://scontent.fmnl2-2.fna.fbcdn.net/v/t39.30808-6/591479561_881279227906241_7398646579035220503_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeHIOXA6wb2mopYnk_m51GowgJiNJHA6_zaAmI0kcDr_Nhicn2J1mr3Yn_F_s9ymXLDPiLINPoIPte5zUyTHAl9w&_nc_ohc=oPW239SfDlEQ7kNvwHgwc7y&_nc_oc=Adm4fpWgWGpWawDQ8GrM7yOA5hG04ODK5af8FRDXNS8BNCVH-SkGb8CsTWdeAUfjj1k&_nc_zt=23&_nc_ht=scontent.fmnl2-2.fna&_nc_gid=rbZo3dWT4nQS4raGEWribg&oh=00_Afp3hSyiu_g4HDITicKeZAuU2n5_i8gzcpgiDKylwu9O-Q&oe=697CF997',
          showPlaceholder: false,
          date: DateTime.now().subtract(Duration(minutes: 13)),
          userImage: 'assets/images/otherprofile.jpg',
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'ABS-CBN',
          postContent: 'Rules are made to be followed, guys',
          likesCount: "781",
          commentsCount: 14,
          sharesCount: 11,
          imagePath: 'assets/images/imagepost2.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile3.jpg',
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'ABS-CBN',
          postContent: "Ang lala! Hindi na 'yan tama. 😢😢😢",
          likesCount: "5.4K",
          commentsCount: 357,
          sharesCount: 158,
          imagePath: 'assets/images/imagepost4.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile3.jpg',
        ),
        buildAdvertisementCarousel(),
        PostCard(
          userName: 'AWS Cloud Clubs Philippines',
          postContent: 'Phase 2 emails are finally here! ^^',
          likesCount: "9",
          commentsCount: 3,
          sharesCount: 3,
          imagePath: 'assets/images/imagepost3.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile2.jpg',
        ),
      ],
    );
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
