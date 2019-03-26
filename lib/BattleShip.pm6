use BattleShip::Ship;

enum Fire        < Miss Hit >;
enum Direction   < North East South West >;
enum Orientation < Horizontal Vertical >;


unit class BattleShip;

has Int  $.x;
has Int  $.y;
has Int  $.count;
has      @!plane;
has Ship @!ships;


submethod BUILD ( Int :$!y = 10, Int :$!x = 10, Int :$!count = 4 ) {

  @!plane = [ '.' xx $!y ] xx $!x;

  @!ships.append: Ship.new for ^$!count;

  self.place-ships;

}


method draw () {

  .put for @!plane;

}

method hunt ( ShipType :$type = Submarine ) {

  for self.filter-coords( :$type ) -> [ $y, $x ] {
    self.target( :$y, :$x, :$type ) if self.fire( :$y, :$x ) ~~ Hit;
  }
}

method target ( :$y!, :$x!, ShipType :$type ) {

  my $ship =  @!ships.first({ $y ∈ .coords.y and $x ∈ .coords.x });
  
  say "($y $x) ({$ship.coords}) {$ship.pieces}"

}

method fire ( :$y!, :$x! --> Fire ) {

  return Hit if @!plane[$y; $x] ~~ Ship::Piece;
  return Miss;

}

method filter-coords ( ShipType :$type --> Seq ) {
  (^$!y X ^$!x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );
}


submethod place-ships () {


  for @!ships {
    .coords = self.rand-coords: type => .type;
    @!plane[.coords.y; .coords.x] = .pieces;
  }

}

submethod rand-coords ( ShipType :$type, Orientation :$orientation = Orientation.roll --> Coords ) {

  my @y = (^$!y).roll;
  my @x = (^$!x).roll;
  
  given $orientation {
  
    when Vertical {
      @y.append: @y[ * - 1 ] + 1 for ^($type - 1);
    }
    when Horizontal {
      @x.append: @x[ * - 1 ] + 1 for ^($type - 1);
    }
  
  }

  my $coords = Coords.new: :@y, :@x;
  return $coords if self.validate-coords: :$coords;
  
  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :$coords --> Bool:D ) {

  return False unless all($coords.y) ∈ ^$!y;
  return False unless all($coords.x) ∈ ^$!x;
  return False unless all(@!plane[$coords.y; $coords.x]) ~~ '.';

  True;

}
