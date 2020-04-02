import 'package:flua/luastate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('', () async {
    var state = LuaState();

    var res = await state.doFile("lua/spec/checktable.lc");
    print(res.toString());

    expect(res.success, true);
  });
}