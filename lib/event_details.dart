import 'package:feather/feather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventDetails extends StatelessWidget {
  final Map event;

  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    var name = get(event, 'name');

    return new Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: new Column(
        children: <Widget>[],
      ),
    );
  }
}
