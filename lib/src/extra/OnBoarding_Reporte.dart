import 'package:adcom/src/methods/slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class OnBoardReportes extends StatefulWidget {
  OnBoardReportes({Key? key}) : super(key: key);

  @override
  _OnBoardReportesState createState() => _OnBoardReportesState();
}

class _OnBoardReportesState extends State<OnBoardReportes> {
  int? pages = 0;
  List<Slide>? _slides = [];
  PageController? _pageController = PageController();

  @override
  void initState() {
    super.initState();
    pages = 0;

    _pageController = PageController(initialPage: pages!);
  }

  final List<OnBoardModel> onBoardData = [
    const OnBoardModel(
      title: "Ayudanos a reportar un problema",
      description: "Si ves algo inusual en tu comunidad puedes reportarlo aquí",
      imgUrl: "assets/images/upload.png",
    ),
    const OnBoardModel(
      title: "Ingresa los datos necesarios para levantar un reporte",
      description: "Podras ver el seguimiento y el estado en el que esta",
      imgUrl: 'assets/images/describe.png',
    ),
    const OnBoardModel(
      title: "Sube tus fotos para dar más detelle del reporte",
      description: "Ayuda a que el seguimiento sea más eficaz",
      imgUrl: 'assets/images/nice.png',
    ),
  ];

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  List<Widget> _buildSlides() {
    return _slides!.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return Column(
      children: [
        SizedBox(
          height: 90,
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(
            slide.heading!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 70,
        ),
        Image.asset(
          slide.image,
          fit: BoxFit.contain,
          width: 300,
          height: 300,
        ),
      ],
    );
  }

  void _handlingOnPage(int page) {
    setState(() {
      pages = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: OnBoard(
          imageHeight: 300,
          imageWidth: 300,
          onBoardData: onBoardData,
          pageController: _pageController!,
          onSkip: () {
            Navigator.of(context).popAndPushNamed('/screen18');
          },
          onDone: () {
            Navigator.of(context).popAndPushNamed('/screen18');
          },
          titleStyles: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.15,
          ),
          descriptionStyles: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          pageIndicatorStyle: const PageIndicatorStyle(
            width: 100,
            inactiveColor: Colors.grey,
            activeColor: Colors.black,
            inactiveSize: Size(8, 8),
            activeSize: Size(12, 12),
          ),
        ));
  }

  _buildPageIndicator() {
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (int i = 0; i < _slides!.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides!.length - 1)
        row.children.add(SizedBox(
          width: 12,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == pages ? 8 : 5,
      height: index == pages ? 8 : 5,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == pages
              ? Color.fromRGBO(136, 144, 178, 1)
              : Color.fromRGBO(206, 209, 223, 1)),
    );
  }

  // ignore: unused_element
  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController!.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      // print("done");
    }
  }

  olderView() {
    Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: PageView(
            controller: _pageController,
            onPageChanged: _handlingOnPage,
            children: _buildSlides(),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Column(
              children: [
                _buildPageIndicator(),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      callback: () {
                        Navigator.of(context).popAndPushNamed('/screen14');
                      },
                      child: _pageController!.initialPage == 1
                          ? Text('Next')
                          : Text(''),
                      gradient: LinearGradient(colors: [
                        Colors.blue[300]!,
                        Colors.blue[400]!,
                        Colors.blue[600]!
                      ]),
                      elevation: 4,
                      increaseHeightBy: 28,
                      increaseWidthBy: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
