// @dart=2.9
import 'package:flutter_candy/model/row_col.dart';
import 'package:flutter_candy/model/tile.dart';

///
/// TileAnimation
///
/// Class which is used to register a Tile animation
class TileAnimation {
  TileAnimation({
    this.animationType,
    this.delay,
    this.from,
    this.to,
    this.tileType,
    this.tile,
  });

  final TileAnimationType animationType;
  final int delay;
  final RowCol from;
  final RowCol to;
  final TileType tileType;
  Tile tile;
}

//
// Types of animations
//
enum TileAnimationType {
  moveDown,
  avalanche,
  newTile,
  chain,
  collapse,
}
