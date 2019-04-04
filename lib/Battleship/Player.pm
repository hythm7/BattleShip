use Battleship::Ship;

unit class Battleship::Player;

has Str $.name ;
has Int $!shots;
has Int $!hits;
has Int $!misses;

has Battleship::Ship @.ship;

method command ( ) {

  $*IN.get;

}
