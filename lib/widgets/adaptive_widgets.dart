import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget scaffold(child) {
  return isApple
      ? CupertinoPageScaffold(
          child: child,
        )
      : Scaffold(
          body: child,
        );
}

PreferredSizeWidget appBar() {
  return isApple
      ? CupertinoNavigationBar(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              // Text('data')
            ],
          ),
        )
      : AppBar(
          actions: [],
        ) as PreferredSizeWidget;
}

bool get isApple => Platform.isMacOS || Platform.isIOS;
