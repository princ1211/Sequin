import 'package:aequin/Mode/radio.dart';
import 'package:aequin/utils/alutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<MyRadio> ra;
  MyRadio _selectedradio;
  Color _selectedcolor;
  bool _isplaying =false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  void initState() {

    super.initState();
    fetchradio();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event==AudioPlayerState.PLAYING){
        _isplaying=true;
      }
      else{
        _isplaying=false;
      }
      setState(() {});

    });

  }


  fetchradio() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    ra= MyRadioList.fromJson(radioJson).radios;
    setState(() {

    });
  }

  playmusic(String url){
    _audioPlayer.play(url);
    _selectedradio=ra.firstWhere((element) => element.url ==url);
    print(_selectedradio.name);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox().size(context.screenWidth,context.screenHeight)
              .withGradient(LinearGradient(
              colors: [
                Alcolor.pricolor1,
                Alcolor.pricolor2,
              ],

              begin: Alignment.topRight,end: Alignment.bottomLeft)).make(),
          AppBar(
            title: "Almusic".text.xl4.bold.white.make().shimmer(
              primaryColor: Vx.purple300, secondaryColor: Vx.white,
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
          ).h(100).p16(),
          VxSwiper.builder(itemCount: ra.length,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            itemBuilder: (context, index){
              final rad = ra[index];
              return VxBox(
                  child: ZStack([
//                Positioned(
//                  top: 0.0,
//                  right: 0.0,
//                  child: VxBox(
//                    child: rad.category.text.uppercase.white.make().px16(),
//                  ).height(40)
//                    .black
//                    .alignCenter
//                    .withRounded(value: 10.0)
//                    .make()
//                ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: VxBox(
                        child:
                        rad.category.text.uppercase.white.make().px16(),
                      )
                          .height(40)
                          .black
                          .alignCenter
                          .withRounded(value: 10.0)
                          .make(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VStack(
                        [
                          rad.name.text.xl3.white.bold.make(),
                          5.heightBox,
                          rad.tagline.text.sm.white.semiBold.make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: [
                          Icon(
                            CupertinoIcons.play_circle,
                            color: Colors.white,
                          ),
                          10.heightBox,
                          "Double tap to play".text.gray300.make(),
                        ].vStack())
                  ],
                  ))
                  .clip(Clip.antiAlias)
                  .bgImage(
                DecorationImage(
                    image: NetworkImage(rad.image),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken)),
              )
                  .border(color: Colors.black, width: 5.0)
                  .withRounded(value: 60.0)
                  .make()
                  .onInkDoubleTap(() {
                playmusic(rad.url);
              }).p16();
            },
          ).centered(),

          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isplaying)
                "Playing Now - ${_selectedradio.name} FM"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                _isplaying
                    ? CupertinoIcons.stop
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isplaying) {
                  _audioPlayer.stop();
                } else {
                  playmusic(_selectedradio.url);
                }
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),

    );
  }
}
