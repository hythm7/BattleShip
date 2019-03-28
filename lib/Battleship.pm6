use Battleship::Player;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Direction   < North East South West >;
enum Orientation < Horizontal Vertical Diagonal >;


unit class Battleship;

has Int    $.x;
has Int    $.y;
has Int    $.count;
has        @!plane;
has Ship   @!ships;
has Player $.player1;
has Player $.player2;


submethod BUILD ( Int :$!y = 20, Int :$!x = 20, Int :$!count = 20 ) {

  @!plane = [ '~' xx $!y ] xx $!x;

  self.place-ships;

}


method draw () {

  @!plane = [ '~' xx $!y ] xx $!x;

  for @!ships {
    @!plane[.coords.y][.coords.x] = .Str for .pieces;
  }

  .put for @!plane;

}

method hunt ( Type :$type = Submarine ) {

  for self.filter-coords( :$type ) -> [ $y, $x ] {
    self.target( :$y, :$x, :$type ) if self.fire( :$y, :$x ) ~~ Hit;
  }
}

method target ( :$y!, :$x!, Type :$type ) {


  say "($y $x) ({$type.coords}) {$type.pieces}"

}

method fire ( :$y!, :$x! --> Fire ) {

  if @!plane[$y; $x] ~~ Ship::Piece {

    my $ship =  @!ships.first({ $y ∈ .coords.y and $x ∈ .coords.x });
    say "You hit { $ship.type } { $ship.name } at ($y, $x)!";
  }

  return Miss;

}

method filter-coords ( Type :$type --> Seq ) {
  (^$!y X ^$!x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );
}


submethod place-ships () {

  for ^$!count {

    my $name = Name.roll;
    my $type = Type.roll;

    @!ships.append: Ship.new( :$name, :$type, :coords(self.rand-coords: :$type) );
  }

}

submethod rand-coords ( Type :$type, Orientation :$orientation = Orientation.roll ) {

  my Coords @coords;

  my $y = (^$!y).roll;
  my $x = (^$!x).roll;

  given $orientation {

    #TODO: Random ±

    do @coords.append: Coords.new: :y($y + $_), :$x         for ^$type when Vertical;
    do @coords.append: Coords.new: :$y, :x($x + $_)         for ^$type when Horizontal;
    do @coords.append: Coords.new: :y($y + $_), :x($x + $_) for ^$type when Diagonal;
  }

  return @coords if self.validate-coords: :@coords;

  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$!y;
  return False unless all(@coords>>.x) ∈ ^$!x;

  so none @coords Xeqv @!ships.map(*.coords).flat;

}
