unit class BattleShip::Coords;

has Int @.x is required;
has Int @.y is required;


method Int () {
  (@!x, @!y);
}

method Str () {
  (@!x, @!y);
}


#multi method move ( North ) {


#}
