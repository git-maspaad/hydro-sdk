import 'package:flua/src/5_2/context.dart';

class CoroutineResult {
  CoroutineResult(this.success, this.values);
  final bool success;
  final List<dynamic> values;

  String toString() {
    return success ? values.map(Context.luaToString).join(", ") : values[0];
  }
}