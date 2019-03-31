unit class Battleship::Coords;

has Int $.y is required is rw;
has Int $.x is required is rw;


#method Int () {
#  (@!y, @!x);
#}

method east ( ) {
  self.new: :$!y, x => $!x + 1;
}

method Str ( ) {
  ($!y, $!x);
}

#multi method move ( North ) {


#}
