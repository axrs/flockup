import 'package:feather/feather.dart';
import 'package:flockup/actions.dart';
import 'package:flutter/material.dart';

void main() => runApp(new Flockup());

class Flockup extends StatelessWidget {
  final AppDbStream stateStream = new AppDbStream(AppDb.onUpdate);

  @override
  Widget build(BuildContext context) {
    fetchEvents();
    return MaterialApp(
        title: 'Flockup',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new StreamBuilder<Map>(
          stream: stateStream,
          initialData: AppDb.init({}).store,
          builder: (context, snapshot) => buildHome(context, snapshot.data),
        ));
  }
}

Widget buildHome(BuildContext context, Map appDb) {
  final List<Map> events = asMaps(get(appDb, 'events', []));
  return Scaffold(
    appBar: AppBar(
      title: new Text("Flockup"),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(events.length.toString()),
        ],
      ),
    ),
  );
}
