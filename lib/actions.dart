import 'dart:convert' show JSON;

import 'package:feather/feather.dart';
import 'package:flockup/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String mapToQueryParam(Map params) {
  return "?" +
      params.entries
          .where((e) => isNotNull(e.value))
          .map((e) => '${e.key}=${e.value}')
          .join("&");
}

const String EVENTS_URL = "https://api.meetup.com/find/upcoming_events";

void fetchEvents() {
  final String url = EVENTS_URL +
      mapToQueryParam({
        "fields": "featured_photo,plain_text_description",
        "key": MEETUP_API_KEY,
        "lat": -19.26639,
        "lon": 146.80569,
        "radius": "smart",
        "sign": "true",
      });

  http.get(url).then((response) {
    var body = JSON.decode(response.body);
    var events = get(body, 'events');
    AppDb.dispatch((Map store) => merge(store, {"events": events}));
  });
}

void navTo(context, view) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => view,
      ));
}
