import 'package:flutter/material.dart';
import 'package:appbar_animated/appbar_animated.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPage(),
    );
  }
}

class DetailPage extends StatelessWidget {
  DetailPage({
    Key? key,
  }) : super(key: key);

  final ColorTween background = ColorTween(
    begin: Colors.transparent,
    end: Colors.blue,
  );
  final ColorTween text = ColorTween(
    begin: Colors.white,
    end: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarColorAnimated(
        backgroundColor: background,
        color: text,
        appBarBuilder: _appBar,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Image.network(
                "https://images.unsplash.com/photo-1600758208050-a22f17dc5bb9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2550&q=80",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.36,
                ),
                height: 900,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(context, bgColor, color) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: Text(
        "AppBar Animate",
        style: TextStyle(
          color: color,
        ),
      ),
      leading: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: color,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
            color: color,
          ),
        ),
      ],
    );
  }
}
