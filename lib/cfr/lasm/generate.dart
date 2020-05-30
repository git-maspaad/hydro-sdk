import 'package:flutter/material.dart';
import 'package:hydro_sdk/cfr/reassembler/hashPrototype.dart';
import 'package:hydro_sdk/cfr/vm/const.dart';
import 'package:hydro_sdk/cfr/vm/prototype.dart';

String lasmPreamble = """
 import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hydro_sdk/cfr/decode/codedump.dart';
import 'package:hydro_sdk/cfr/lasm/stub.dart';
import 'package:hydro_sdk/cfr/thread/threadResult.dart';
import 'package:hydro_sdk/cfr/vm/frame.dart';
import 'package:hydro_sdk/cfr/vm/local.dart';
import 'package:hydro_sdk/cfr/vm/prototype.dart';
import 'package:hydro_sdk/cfr/vm/upvaldef.dart';
import 'package:hydro_sdk/cfr/vm/const.dart';
import 'package:hydro_sdk/cfr/vm/context.dart';
import 'package:hydro_sdk/cfr/vm/prototype.dart';
import 'package:hydro_sdk/cfr/vm/instructions/add.dart';
import 'package:hydro_sdk/cfr/vm/instructions/call.dart';
import 'package:hydro_sdk/cfr/vm/instructions/closure.dart';
import 'package:hydro_sdk/cfr/vm/instructions/concat.dart';
import 'package:hydro_sdk/cfr/vm/instructions/div.dart';
import 'package:hydro_sdk/cfr/vm/instructions/eq.dart';
import 'package:hydro_sdk/cfr/vm/instructions/forloop.dart';
import 'package:hydro_sdk/cfr/vm/instructions/forprep.dart';
import 'package:hydro_sdk/cfr/vm/instructions/gettable.dart';
import 'package:hydro_sdk/cfr/vm/instructions/gettabup.dart';
import 'package:hydro_sdk/cfr/vm/instructions/getupval.dart';
import 'package:hydro_sdk/cfr/vm/instructions/jmp.dart';
import 'package:hydro_sdk/cfr/vm/instructions/le.dart';
import 'package:hydro_sdk/cfr/vm/instructions/len.dart';
import 'package:hydro_sdk/cfr/vm/instructions/loadbool.dart';
import 'package:hydro_sdk/cfr/vm/instructions/loadk.dart';
import 'package:hydro_sdk/cfr/vm/instructions/loadkx.dart';
import 'package:hydro_sdk/cfr/vm/instructions/loadnil.dart';
import 'package:hydro_sdk/cfr/vm/instructions/lt.dart';
import 'package:hydro_sdk/cfr/vm/instructions/mod.dart';
import 'package:hydro_sdk/cfr/vm/instructions/move.dart';
import 'package:hydro_sdk/cfr/vm/instructions/mul.dart';
import 'package:hydro_sdk/cfr/vm/instructions/newtable.dart';
import 'package:hydro_sdk/cfr/vm/instructions/not.dart';
import 'package:hydro_sdk/cfr/vm/instructions/pow.dart';
import 'package:hydro_sdk/cfr/vm/instructions/return.dart';
import 'package:hydro_sdk/cfr/vm/instructions/self.dart';
import 'package:hydro_sdk/cfr/vm/instructions/setlist.dart';
import 'package:hydro_sdk/cfr/vm/instructions/settable.dart';
import 'package:hydro_sdk/cfr/vm/instructions/settabup.dart';
import 'package:hydro_sdk/cfr/vm/instructions/setupval.dart';
import 'package:hydro_sdk/cfr/vm/instructions/sub.dart';
import 'package:hydro_sdk/cfr/vm/instructions/tailcall.dart';
import 'package:hydro_sdk/cfr/vm/instructions/test.dart';
import 'package:hydro_sdk/cfr/vm/instructions/testset.dart';
import 'package:hydro_sdk/cfr/vm/instructions/tforcall.dart';
import 'package:hydro_sdk/cfr/vm/instructions/tforloop.dart';
import 'package:hydro_sdk/cfr/vm/instructions/unm.dart';
import 'package:hydro_sdk/cfr/vm/instructions/vararg.dart';
""";

String generateStubClasses({@required Prototype prototype}) {
  String res = "";

  res += """

class \$${hashPrototype(prototype,includeSourceLocations: false)} extends LasmStub {
\$${hashPrototype(prototype,includeSourceLocations: false)}(CodeDump root, {@required this.parent}) : super(root,parent:parent);

Prototype parent;
  """;

  res += """
    int lineStart=${prototype.lineStart};
    int lineEnd=${prototype.lineEnd};
    int params=${prototype.params};
    int vararg=${prototype.varag};
    int registers = ${prototype.registers};
    Int32List rawCode = Int32List.fromList(${prototype.rawCode});
    
    List<Const> constants = [
  """;

  prototype.constants.forEach((x) {
    if (x.type == ConstType.CONST_NIL) {
      res += "Const(),\n";
    }
    if (x.type == ConstType.CONST_BOOL) {
      res += "BoolConst(${x.value}),\n";
    }
    if (x.type == ConstType.CONST_NUMBER) {
      res += "NumberConst(${x.value}),\n";
    }
    if (x.type == ConstType.CONST_STRING) {
      res +=
          "StringConst(\"${(x.value as String).replaceAll("\$", "\\\$").replaceAll("\n", "\\n")}\"),\n";
    }
  });
  res += "];\n";

  res += "List<UpvalDef> upvals =[\n";

  prototype.upvals.forEach((x) {
    res += "UpvalDef(${x.stack},${x.reg}),\n";
  });
  res += "];\n";

  res += " String source = ${prototype.source};\n";

  res += "List<Local> locals =[\n";

  prototype.locals.forEach((x) {
    res += "Local(${x.name},${x.from},${x.to}),\n";
  });
  res += "];\n";

  res +=
      """ThreadResult Function({@required Frame frame, @required Prototype prototype}) interpreter= ({@required Frame frame, @required Prototype prototype}){
    while(true){
      switch(frame.programCounter){
    """;

  for (var i = 0; i != prototype.code.list.length; ++i) {
    print(prototype.code.list[i].OP);
    switch (prototype.code.list[i].OP) {
      case 0:
        res += "case $i:\n";
        res +=
            "move(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 1:
        res += "case $i:\n";
        res +=
            "loadk(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 2:
        res += "case $i:\n";
        res +=
            "loadkx(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 3:
        res += "case $i:\n";
        res +=
            "loadbool(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 4:
        res += "case $i:\n";
        res +=
            "loadnil(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 5:
        res += "case $i:\n";
        res +=
            "getupval(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 6:
        res += "case $i:\n";
        res +=
            "gettabup(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 7:
        res += "case $i:\n";
        res +=
            "gettable(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 8:
        res += "case $i:\n";
        res +=
            "settabup(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 9:
        res += "case $i:\n";
        res +=
            "setupval(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 10:
        res += "case $i:\n";
        res +=
            "settable(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 11:
        res += "case $i:\n";
        res += "newtable(frame:frame,A:${prototype.code.list[i].A},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 12:
        res += "case $i:\n";
        res +=
            "self(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 13:
        res += "case $i:\n";
        res +=
            "add(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 14:
        res += "case $i:\n";
        res +=
            "sub(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 15:
        res += "case $i:\n";
        res +=
            "mul(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 16:
        res += "case $i:\n";
        res +=
            "div(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 17:
        res += "case $i:\n";
        res +=
            "mod(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 18:
        res += "case $i:\n";
        res +=
            "instPow(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 19:
        res += "case $i:\n";
        res += "unm(frame:frame,A:${prototype.code.list[i].A},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 20:
        res += "case $i:\n";
        res +=
            "not(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 21:
        res += "case $i:\n";
        res +=
            "not(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 22:
        res += "case $i:\n";
        res +=
            "concat(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 23:
        res += "case $i:\n";
        res +=
            "jmp(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 24:
        res += "case $i:\n";
        res +=
            "eq(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 25:
        res += "case $i:\n";
        res +=
            "lt(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 26:
        res += "case $i:\n";
        res +=
            "le(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 27:
        res += "case $i:\n";
        res +=
            "test(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 28:
        res += "case $i:\n";
        res +=
            "testset(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 29:
        res += "case $i:\n";
        res += """
        var res = call(frame: frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});
          if (res != null) {
            return res;
          }
        """;
        res += "break;\n";
        break;
      case 30:
        res += "case $i:\n";
        res += """
        var res = tailcall(frame: frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});
          if (res != null) {
            return res;
          }
        """;
        res += "break;\n";
        break;
      case 31:
        res += "case $i:\n";
        res +=
            "instReturn(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 32:
        res += "case $i:\n";
        res +=
            "forloop(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 33:
        res += "case $i:\n";
        res +=
            "forprep(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 34:
        res += "case $i:\n";
        res +=
            "tforcall(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 35:
        res += "case $i:\n";
        res +=
            "tforloop(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 36:
        res += "case $i:\n";
        res +=
            "setlist(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},C:${prototype.code.list[i].C});\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 37:
        res += "case $i:\n";
        res +=
            "closure(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
      case 38:
        res += "case $i:\n";
        res +=
            "instVararg(frame:frame,A:${prototype.code.list[i].A},B:${prototype.code.list[i].B},);\n";
        res += "frame.programCounter++;\n";
        res += "break;\n";
        break;
    }
  }

  res += """
    }
    }
    };
    }
  """;
  return res;
}

String thunkPreamble = """
Map<String, LasmStub Function({CodeDump codeDump, Prototype parent})> thunks = {
""";

String generateThunk({@required Prototype prototype}) {
  String res = "";

  res += """
"${hashPrototype(prototype,includeSourceLocations: false)}": ({
    CodeDump codeDump,
    Prototype parent,
  }) =>
      \$${hashPrototype(prototype,includeSourceLocations: false)}(
          codeDump,
          parent: parent),
  """;
  return res;
}

String thunkPostAmble = "};";
