// @dart=2.9
import 'package:flutter_candy/model/tile.dart';

///
/// ObjectiveEvent
///
/// Event which is emitted each time a "potential" objective
/// (normal tile being removed, bomb that explodes...)
///
class ObjectiveEvent {
  final TileType type;
  // Remaining before reaching the objective for this type of Objective
  final int remaining;

  ObjectiveEvent({
    this.type,
    this.remaining,
  });
}
