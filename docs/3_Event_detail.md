# Phase 3
## Showing some event detail

Now that we have some details displayed about each event, it's time to drill down further for detail. Let's start by
defining an `EventDetailWidget`.

1. Create a new `event_details.dart` file.
2. Create a new `StatelessWidget` to show more details about our event

 ```dart
// event_details.dart
//
// Add in some packages to make our lives easier
//
import 'package:feather/feather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//
// Create the new StatelessWidget (because we won't be modifying the event)
//
class EventDetails extends StatelessWidget {
  final Map event;

  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    var name = get(event, 'name');

    //
    // Keeping with the layout of the app already, lets use Scaffold again
    //
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
 ```

3. Add an action to navigate to this view from our main list

```dart
// actions.dart
//
// Import the material package to gain access to the `Navigator`
//
...
import 'package:flutter/material.dart';
...

//
// Add a `navTo` function to push the new view into the stack for us
//
void navTo(context, view) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => view,
      ));
}
...

```

4. Wire up the navigation action to a touch event on an event list item
  1. Import our `event_details.dart` so we can access our new widget
```dart
// main.dart
...
//
// Import our new Event details widget
//
import 'package:flockup/event_details.dart';
...
```

  2. Within the `buildEventListItem`, we'll create a new function to add an `onTap` handler for public events. We can do
  this by wrapping our current Widget tree in an Inkwell (A rectangular area of a Material that responds to touch).

```dart
Widget buildEventListItem(BuildContext context, Map event) {

...
  //
  // Create a new function to wrap the current layout in an `Inkwell`
  //
  Widget inkwellIfPublic(Widget child) {
    if (!isPublic) {
      //
      // The event isn't public, so we have no more details to show. Let's not make that event tappable
      //
      return child;
    }
    return new InkWell(
      onTap: () => navTo(context, new EventDetails(event)),
      child: child,
    );
  }

...

  return new Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: inkwellIfPublic(                     // <-- New
      Column(children: <Widget>[
        header,
        imageOrPlaceholder(),
        footer,
      ]),
    ),
  );
}

```
