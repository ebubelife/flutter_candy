//@dart=2.9
import 'package:flutter_candy/application.dart';
import 'package:flutter_candy/helpers/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_candy/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  // Initialize the audio
  //
  await Audio.init();

  //
  // Remove the status bar
  //
  SystemChrome.setEnabledSystemUIOverlays([]);

  return runApp(
    Application(),
  );
}
