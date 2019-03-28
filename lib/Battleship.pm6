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


submethod BUILD ( Int :$!y = 10, Int :$!x = 10, Int :$!count = 5 ) {

  @!plane = [ '~' xx $!y ] xx $!x;


  self.place-ships;

}


method draw () {

  @!plane = [ '~' xx $!y ] xx $!x;

  for @!ships {
    #  @!plane[.coords>>.y; .coords>>.x] = .pieces;
    @!plane[.coords.y][.coords.x] = .Str for .pieces;
     #say @!plane[.y][.x];
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

  my Int     @y;
  my Int     @x;
  my Coords @coords;

  given $orientation {
  
    when Vertical {
      my $y = (^$!y).roll;
      my $x = (^$!x).roll;

      @y.append: $y + $++  for ^$type;
      @x.append: $x;

      @coords.append: (@y X @x).map( -> [ $y, $x ] { Coords.new: :$y, :$x } );
    }

    when Horizontal {
      my $y = (^$!y).roll;
      my $x = (^$!x).roll;

      @y.append: $y;
      @x.append: $x + $++  for ^$type;

      @coords.append: (@y X @x).map( -> [ $y, $x ] { Coords.new: :$y, :$x } );
    }

    when Diagonal {
      my $y = (^$!y).roll;
      my $x = (^$!x).roll;

      @y.append: $y;
      @x.append: $x + $++  for ^$type;

      @coords.append: (@y X @x).map( -> [ $y, $x ] { Coords.new: :$y, :$x } );
      @coords[0].y -= 1; 
      @coords[*-1].y += 1; 
    }
  
  }

  return @coords if self.validate-coords: :@coords;
  
  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$!y;
  return False unless all(@coords>>.x) ∈ ^$!x;

  #return False unless all(@!plane[$coords.y; $coords.x]) ~~ '~';

  True;

}
