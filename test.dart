void main() {
  nextBigger(int n) {
    List m = n.toString().split('');

    if (n.toString().length >= 1) {
      m.sort();
      m = m.reversed.toList();
      print(m);

      return int.parse(m.join()) > n
          ? int.parse(m.join())
          : int.parse(m.join()) == n ? -1 : nextBigger(n);
    } else {
      return -1;
    }
  }

  print(nextBigger(2017));
}
