
unit class Battleship::Coords;

has Int $.y is required is rw;
has Int $.x is required is rw;


#method Int () {
#  (@!y, @!x);
#}

method north ( Int $i = 1 ) {
  self.new: y => $!y - $i, x => $!x;
}

method south ( Int $i = 1 ) {
  self.new: y => $!y + $i, x => $!x;
}

method east ( Int $i = 1 ) {
  self.new: y => $!y, x => $!x + $i;
}

method west ( Int $i = 1 ) {
  self.new: y => $!y, x => $!x - $i;
}

method northeast ( Int $i = $i ) {
  self.new: y => $!y - $i, x => $!x + $i;
}

method northwest ( Int $i = 1 ) {
  self.new: y => $!y - $i, x => $!x - $i;
}

method southeast ( Int $i = 1 ) {
  self.new: y => $!y + $i, x => $!x + $i;
}

method southwest ( Int $i = 1 ) {
  self.new: y => $!y + $i, x => $!x - $i;
}

method Str ( ) {
  ($!y, $!x);
}

#multi method move ( North ) {


#}
