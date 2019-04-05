use Battleship::Ship;

unit class Battleship::Player;

has Str $.name ;
has Int $.shots  is rw = 0;
has Int $.hits   is rw = 0;
has Int $.misses is rw = 0;
has Int $.moves  is rw = 0;

has Battleship::Ship @.ship;

method command ( ) {

  $*IN.get;

}
