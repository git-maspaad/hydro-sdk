import 'package:hydro_sdk/hydroState.dart';
import 'package:hydro_sdk/cfr/vm/context.dart';
import 'package:hydro_sdk/cfr/builtins/flutter/syntheticBox.dart';
import 'package:hydro_sdk/cfr/vm/table.dart';
import 'package:flutter/material.dart';

void loadTransform({@required HydroState luaState, @required HydroTable table}) {
  table["transformRotate"] = makeLuaDartFunc(func: (List<dynamic> args) {
    return [
      Transform.rotate(
        key: maybeUnwrapAndBuildArgument<Key>(args[0]["key"],
            parentState: luaState),
        angle: args[0]["angle"],
        origin: maybeUnwrapAndBuildArgument<Offset>(args[0]["origin"],
            parentState: luaState),
        alignment: maybeUnwrapAndBuildArgument<Alignment>(args[0]["alignment"],
            parentState: luaState),
        transformHitTests: args[0]["transformHitTests"],
        child: maybeUnwrapAndBuildArgument<Widget>(args[0]["child"],
            parentState: luaState),
      )
    ];
  });

  table["transformTranslate"] = makeLuaDartFunc(func: (List<dynamic> args) {
    return [
      Transform.translate(
        key: maybeUnwrapAndBuildArgument<Key>(args[0]["key"],
            parentState: luaState),
        offset: maybeUnwrapAndBuildArgument<Offset>(args[0]["offset"],
            parentState: luaState),
        transformHitTests: args[0]["transformHitTests"],
        child: maybeUnwrapAndBuildArgument<Widget>(args[0]["child"],
            parentState: luaState),
      )
    ];
  });

  table["transformScale"] = makeLuaDartFunc(func: (List<dynamic> args) {
    return [
      Transform.scale(
        key: maybeUnwrapAndBuildArgument<Key>(args[0]["key"],
            parentState: luaState),
        scale: args[0]["scale"],
        origin: maybeUnwrapAndBuildArgument<Offset>(args[0]["origin"],
            parentState: luaState),
        alignment: maybeUnwrapAndBuildArgument<Alignment>(args[0]["alignment"],
            parentState: luaState),
        transformHitTests: args[0]["transformHitTests"],
        child: maybeUnwrapAndBuildArgument<Widget>(args[0]["child"],
            parentState: luaState),
      )
    ];
  });
}
