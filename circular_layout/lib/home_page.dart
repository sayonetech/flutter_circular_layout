import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

const double _radiansPerDegree = Math.pi / 180;
final double _startAngle = -90.0 * _radiansPerDegree;

typedef double ItemAngleCalculator(int index);

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  final List<Widget> items = [
    new Container(
      decoration: new BoxDecoration(shape: BoxShape.circle,
      ),
      child: new MaterialButton(
        onPressed: () {},
        child: new Image.asset(
          'images/recycling.png',
          width: 60.0,
          height: 60.0,
          fit: BoxFit.cover,
        ),
      ),
    ),
    new FlatButton(
      onPressed: () {},
      child: new Image.asset(
        'images/gas-station.png',
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    ),
    new FlatButton(
      onPressed: () {},
      child: new Image.asset(
        'images/light-bulb.png',
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    ),
    new FlatButton(
      onPressed: () {},
      child: new Image.asset(
        'images/cflamp.png',
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    ),
    new FlatButton(
      onPressed: () {},
      child: new Image.asset(
        'images/plug.png',
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.teal),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
              child: new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      new Color(0xFFA19D9A),
                      Colors.white,
                      new Color(0xFFA19D9A),
                    ]),
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(25.0))),
                child: new Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                      color: Colors.teal,
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(22.0))),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text(
                      "Get recommendations by selecting any icon",
                      style: new TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontFamily: 'CaviarDreams',
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            _buildStackView(),
          ],
        ),
      ),
    );
  }

  Widget _buildStackView() {
    final List<Widget> beverages = <Widget>[];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double outerRadius = Math.min(width * 3 / 4, height * 3 / 4);
    double innerWhiteRadius = outerRadius * 3 / 4;

    for (int i = 0; i < items.length; i++) {
      beverages.add(_buildIcons(i));
    }

    return Flexible(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            _drawCircle(outerRadius, Color.fromRGBO(255, 255, 255, 0.3)),
            _drawCircle(outerRadius - 25, Color.fromRGBO(255, 255, 255, 0.2)),
            new CustomMultiChildLayout(
              delegate: new _CircularLayoutDelegate(
                itemCount: items.length,
                radius: outerRadius / 2,
              ),
              children: beverages,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("/ask/capture");
                },
                child: Image.asset(
                  "images/earth-globe.png",
                  width: innerWhiteRadius,
                  height: innerWhiteRadius,
                  fit: BoxFit.cover,
                )
            ),
          ],
        ),
      ),
    );
  }

  // Draw a circle with given radius and color.
  Widget _drawCircle(double radius, Color color) {
    return new Container(
      decoration: new BoxDecoration(shape: BoxShape.circle, color: color),
      width: radius,
      height: radius,
    );
  }



  Widget _buildIcons(int index) {
    final Widget item = items[index];

    return new LayoutId(
      id: 'BUTTON$index',
      child: item,
    );
  }
}

double _calculateItemAngle(int index) {
  double _itemSpacing = 360.0 / 5.0;
  return _startAngle + index * _itemSpacing * _radiansPerDegree;
}

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  static const String actionButton = 'BUTTON';

  final int itemCount;
  final double radius;

  _CircularLayoutDelegate({
    @required this.itemCount,
    @required this.radius,
  });

  Offset center;

  @override
  void performLayout(Size size) {
    center = new Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < itemCount; i++) {
      final String actionButtonId = '$actionButton$i';

      if (hasChild(actionButtonId)) {
        final Size buttonSize =
        layoutChild(actionButtonId, new BoxConstraints.loose(size));

        final double itemAngle = _calculateItemAngle(i);

        positionChild(
          actionButtonId,
          new Offset(
            (center.dx - buttonSize.width / 2) + (radius) * Math.cos(itemAngle),
            (center.dy - buttonSize.height / 2) +
                (radius) * Math.sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
          radius != oldDelegate.radius ;
}
