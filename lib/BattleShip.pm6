use BattleShip::Ship;

enum Fire < Miss Hit >;
enum Direction < North East South West >;

unit class BattleShip;

has                    @!plane;
has BattleShip::Ship   @!ship;
has BattleShip::Coords @!coords;

submethod BUILD ( Int :$x = 10, Int :$y = 10 ) {

  @!coords = (^$x X ^$y).map( -> [ $x, $y ] { BattleShip::Coords.new: :$x, :$y } );

  @!plane[.x][.y] = '.' for @!coords;
  
  @!ship.push: BattleShip::Ship.new(Submarine) for ^@!coords.elems;

  self.place-ships;

}


method draw () {

  .put for @!plane;

}

method hunt ( ShipType :$ship ) {

  for self.filter-coords( :$ship ) -> $coords {

    self.target( :$coords, :$ship ) if self.fire( :$coords ) ~~ Hit;

  }
}

method target ( BattleShip::Coords :$coords!, ShipType :$ship ) {

  say "Found $ship at $coords";

}

method fire ( BattleShip::Coords :$coords! --> Fire ) {

  return Hit if @!plane[$coords.x; $coords.y] ~~ BattleShip::Ship::Piece;
  return Miss;

}

method filter-coords ( ShipType :$ship --> Seq ) {
  @!coords.grep( { (.x + .y) %% $ship } );
}


submethod place-ships () {

  for @!ship -> $ship {

    

  }

  @!plane[ 0; 2, 3, 4 ] = @!ship[0].pieces;
  @!plane[ 1; 3, 4, 5 ] = @!ship[1].pieces;
  @!plane[ 5; 6, 7, 8 ] = @!ship[2].pieces;
  @!plane[ 7; 7, 8, 9 ] = @!ship[3].pieces;
  @!plane[ 1, 2, 3; 0 ] = @!ship[4].pieces;
  @!plane[ 2, 3, 4; 3 ] = @!ship[5].pieces;
  @!plane[ 6, 7, 8; 6 ] = @!ship[6].pieces;
  @!plane[ 7, 8, 9; 2 ] = @!ship[7].pieces;

}
