use Battleship::Player;
use Battleship::Ship;

unit class Battleship::AI;
  also is Battleship::Player;

enum Name < Ghost AI Majesty Camelia >;

has Str $.name     = Name.pick.Str;
has Bool $.hidden  = False;
has Int  $.board-y = 20;
has Int  $.board-x = 20;
has Int  $.speed   = 2;


method command ( ) {
  sleep 7 / $!speed;

  my $y = (^$.board-y).roll;
  my $x = (^$.board-x).roll;

  my $command = "f {$y} {$x}";

  $command;
}

method hunt ( Type :$type = Destroyer ) {

  for self.filter-coords( :$type ) -> [ $y, $x ] {
    self.target( :$y, :$x, :$type );
  }
}

method target ( :$y!, :$x!, Type :$type ) {



}

method filter-coords ( Type :$type --> Seq ) {
  (^$!board-y X ^$!board-x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );
}

