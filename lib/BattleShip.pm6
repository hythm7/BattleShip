use BattleShip::Ship;

enum Fire < Miss Hit >;
enum Direction < North East South West >;

unit class BattleShip;

has                    @!plane;
has BattleShip::Ship   @!ships;

submethod BUILD ( Int :$x = 10, Int :$y = 10 ) {

  #@!coords = (^$x X ^$y).map( -> [ $x, $y ] { BattleShip::Coords.new: :$x, :$y } );

  @!plane = [ '.' xx $x ] xx $y;
  

  self.place-ships;

}


method draw () {

  .put for @!plane;

}

method hunt ( ShipType :$ship ) {

  #for self.filter-coords( :$ship ) -> $coords {

    #self.target( :$coords, :$ship ) if self.fire( :$coords ) ~~ Hit;

    #}

  for self.filter-coords( :$ship ) -> [ $x, $y ] {
    self.target( :$x, :$y, :$ship ) if self.fire( :$x, :$y ) ~~ Hit;
  }
}

method target ( :$x!, :$y!, ShipType :$ship ) {

  say "Found $ship at ($y, $x)";

}

method fire ( :$x!, :$y! --> Fire ) {

  return Hit if @!plane[$x; $y] ~~ BattleShip::Ship::Piece;
  return Miss;

}

method filter-coords ( ShipType :$ship --> Seq ) {
  #@!coords.grep( { (.x + .y) %% $ship } );
  (^10 X ^10).grep( -> [ $x, $y ] { ($x + $y) %% $ship } );
}


submethod place-ships () {

  my BattleShip::Coords $coords = BattleShip::Coords.new: x => (0), y => (1, 2, 3);

  @!ships.push: BattleShip::Ship.new( type => Submarine, :$coords );

  for @!ships {
    @!plane[.coords.x;.coords.y] = .pieces;
  }

    #@!plane[ 0; 2, 3, 4 ] = @!ship[0].pieces;
    #@!plane[ 1; 3, 4, 5 ] = @!ship[1].pieces;
    # @!plane[ 5; 6, 7, 8 ] = @!ship[2].pieces;
    #@!plane[ 7; 7, 8, 9 ] = @!ship[3].pieces;
    #@!plane[ 1, 2, 3; 0 ] = @!ship[4].pieces;
    #@!plane[ 2, 3, 4; 3 ] = @!ship[5].pieces;
    #@!plane[ 6, 7, 8; 6 ] = @!ship[6].pieces;
    #@!plane[ 7, 8, 9; 2 ] = @!ship[7].pieces;


}
