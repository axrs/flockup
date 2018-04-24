import 'package:feather/feather.dart';
import 'package:flockup/actions.dart';
import 'package:flockup/event_details.dart';
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
          new Expanded(
            child: new EventListWidget(events),
          ),
        ],
      ),
    ),
  );
}

class EventListWidget extends StatelessWidget {
  final List<Map> events;
  final ScrollController scrollController;

  EventListWidget(this.events) : scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: events.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int itemIndex) {
        if (itemIndex <= events.length) {
          return buildEventListItem(context, events[itemIndex]);
        }
      },
    );
  }
}

Widget buildEventListItem(BuildContext context, Map event) {
  final String time = get(event, 'local_time', '');
  final bool isPublic = get(event, 'visibility') == 'public';
  final IconData visibilityIcon = isPublic ? Icons.lock_open : Icons.lock;
  final TextTheme theme = Theme.of(context).accentTextTheme;
  final String group = getIn(event, ['group', 'name'], '');
  final String name = get(event, 'name', '');

  var header = new Container(
    decoration: new BoxDecoration(
      color: Theme.of(context).primaryColor,
    ),
    child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            name,
            style: theme.body2,
            overflow: TextOverflow.ellipsis,
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
            ),
          ),
          new Text(
            group,
            style: theme.body1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  var footer = new Container(
    decoration: new BoxDecoration(
      color: Colors.black.withOpacity(0.6),
    ),
    child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: nonNullWidgets([
          Icon(
            visibilityIcon,
            color: theme.body2?.color,
            size: theme.body2?.fontSize,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  time,
                  style: theme.body2,
                ),
              ],
            ),
          ),
        ]),
      ),
    ),
  );

  Widget imageOrPlaceholder() {
    final String photo = getIn(event, ['featured_photo', 'photo_link']);
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: ifVal(
          photo,
          (_) => Image.network(
                photo,
                fit: BoxFit.cover,
              ),
          (_) => Container(
                color: Colors.grey.withOpacity(0.3),
                child: new Icon(
                  Icons.image,
                  size: 44.0,
                ),
              )),
    );
  }

  Widget inkwellIfPublic(Widget child) {
    if (!isPublic) {
      return child;
    }
    return new InkWell(
      onTap: () => navTo(context, new EventDetails(event)),
      child: child,
    );
  }

  return new Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: inkwellIfPublic(
      Column(children: <Widget>[
        header,
        imageOrPlaceholder(),
        footer,
      ]),
    ),
  );
}
