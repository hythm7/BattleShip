use Battleship::Player;
use Battleship::Ship;

unit class Battleship::AI;
  also is Battleship::Player;

enum Name < Ghost Salmon Deepblue Warrior Majesty >;

has Int $.board-y = 20;
has Int $.board-x = 20;

has Str $.name = 'AI';



method command ( ) {
  sleep 2;

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


  say "($y $x) ({$type.coords}) {$type.pieces}"

}

method filter-coords ( Type :$type --> Seq ) {
  (^$!board-y X ^$!board-x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );
}

