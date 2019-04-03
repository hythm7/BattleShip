use Battleship::Player;
use Battleship::Ship;

unit class Battleship::AI;
  also is Battleship::Player;

enum Name < Ghost Salmon Deepblue Warrior Majesty >;

has Int $.board-y = 20;
has Int $.board-x = 20;

has Str $.name = 'AI';
has Battleship::Ship @.ship;

submethod BUILD ( ) {

  for Submarine, Submarine, Cruiser, Cruiser, Carrier -> $type {
    @!ship.append: Battleship::Ship.new: name => Name.pick.Str, :$type;
  }

}

method hunt ( Type :$type = Submarine ) {

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

