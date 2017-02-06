import 'package:test/test.dart' as unit;
import 'package:k07me.prop/prop.dart';

void main() {
  unit.test("basic a", () {
    var prop = new MiniProp();
    prop.setPropString("a", "b", "c");
    prop.setPropString("b", "c1", "d1");
    prop.setPropNum("b", "c2", 2);
    unit.expect(prop.toJson(), """{"a":{"b":"c"},"b":{"c1":"d1","c2":2}}""");
    unit.expect("c", prop.getPropString("a", "b", ""));
    unit.expect("d1", prop.getPropString("b", "c1", ""));
    unit.expect(2, prop.getPropNum("b", "c2", 1));
  });

  unit.test("basic b", () {
    var prop = new MiniProp();
    prop.setPropString("a", "b", "c");
    prop.setPropString("b", "c1", "d1");
    prop.setPropNum("b", "c2", 2.1);
    unit.expect(prop.toJson(), """{"a":{"b":"c"},"b":{"c1":"d1","c2":2.1}}""");
    unit.expect("d", prop.getPropString("b", "c2", "d"));
    unit.expect("d", prop.getPropString("b", "c3", "d"));
  });
}
