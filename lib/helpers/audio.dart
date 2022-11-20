import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Audio {
  static AudioCache player = AudioCache();

  //
  // Initialization.  We pre-load all sounds.
  //
  static Future<dynamic> init() async {
    await player.loadAll([
      'audio/swap.wav',
      'audio/move_down.wav',
      'audio/bomb.wav',
      'audio/game_start.wav',
      'audio/win.wav',
      'audio/lost.wav',
    ]);
  }

  static play() async {
    AudioPlayer player = AudioPlayer();
    player.setVolume(1.0);
    await player.setSourceAsset("assets/audio/swap.wav");
    player.play(AssetSource("assets/audio/swap.wav"));
  }

  static playAsset(AudioType audioType) {
    AudioPlayer player = AudioPlayer();
    player.setVolume(1);
    player.setSourceAsset('audio/${describeEnum(audioType)}.wav');
    player.play(AssetSource("audio/${describeEnum(audioType)}.wav"));
  }
}

enum AudioType {
  swap,
  move_down,
  bomb,
  game_start,
  win,
  lost,
}
