part of routing;





class Tuple<A, B> {

  final A fst;
  final B snd;

  Tuple(this.fst, this.snd);

  int get hashCode {
    fst.hashCode + 31 * snd.hashCode;
  }

  String toString() => "Tuple($fst, $snd)";
}

List<Tuple> zip(List fsts, List snds) {
  var z = <Tuple>[];
  int l = math.min(fsts.length, snds.length);
  for (int i = 0; i < l; i++) {
    z.add(new Tuple(fsts[i], snds[i]));
  }
  return z;
}
