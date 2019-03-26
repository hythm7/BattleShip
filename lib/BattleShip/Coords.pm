unit class BattleShip::Coords;

has Int $.x is required;
has Int $.y is required;

method new ( $x, $y ) {
  self.bless( :$x, :$y );
}

method Int () {
  ($!x, $!y);
}

method Str () {
  "($!x, $!y)";
}

method coords {

 ($!x, $!y); 

}

#multi method move ( North ) {


#}
