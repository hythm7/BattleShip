unit class BattleShip::Coords;

has Int @.y is required;
has Int @.x is required;


#method Int () {
#  (@!y, @!x);
#}

method Str () {
  (@!y, @!x);
}

#multi method move ( North ) {


#}
