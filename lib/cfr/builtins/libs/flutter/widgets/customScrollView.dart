import 'package:flutter/gestures.dart';
import 'package:hydro_sdk/cfr/builtins/boxing/unboxers.dart';
import 'package:hydro_sdk/hydroState.dart';
import 'package:hydro_sdk/cfr/vm/context.dart';
import 'package:hydro_sdk/cfr/vm/table.dart';
import 'package:flutter/material.dart';

void loadCustomScrollView(
    {@required HydroState luaState, @required HydroTable table}) {
  table["customScrollView"] = makeLuaDartFunc(func: (List<dynamic> args) {
    return [
      CustomScrollView(
        key: maybeUnBoxAndBuildArgument<Key>(args[0]["key"],
            parentState: luaState),
        scrollDirection: maybeUnBoxEnum(
            values: Axis.values, boxedEnum: args[0]["scrollDirection"]),
        reverse: args[0]["reverse"],
        primary: args[0]["primary"],
        physics: maybeUnBoxAndBuildArgument<ScrollPhysics>(args[0]["physics"],
            parentState: luaState),
        shrinkWrap: args[0]["shrinkWrap"],
        center: maybeUnBoxAndBuildArgument<Key>(args[0]["center"],
            parentState: luaState),
        anchor: args[0]["anchor"]?.toDouble(),
        cacheExtent: args[0]["cacheExtent"]?.toDouble(),
        slivers: maybeUnBoxAndBuildArgument<Widget>(args[0]["slivers"],
            parentState: luaState),
        semanticChildCount: args[0]["semanticChildCount"],
        dragStartBehavior: maybeUnBoxEnum(
            values: DragStartBehavior.values,
            boxedEnum: args[0]["dragStartBehavior"]),
      )
    ];
  });
}
