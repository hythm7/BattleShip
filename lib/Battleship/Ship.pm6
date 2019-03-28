use Battleship::Coords;
use Battleship::Ship::Piece;

enum Name < Turtle Alligator Whale Bass Bonita Shark Seal Salmon Seawolf Tarpon Cuttlefish >;
enum Type ( Destroyer => 2, Submarine => 3, Cruiser => 4, Carrier => 5);
enum State < Swim Sink >;

unit class Battleship::Ship;

has Name  $.name is required;
has Type  $.type is required;
has Piece @.pieces;

has Battleship::Coords @.coords is required;             

has State $!state;

submethod BUILD ( Name :$!name, Type :$!type, Battleship::Coords :@!coords ) {

  my $shape = ShipPiece.pick;

  for @!coords -> $coords {

    @!pieces.append: Piece.new( :$shape, :$coords );

  }
  
  $!state = Swim;

}

#method coords () {
#  @!pieces.map(*.coords);
#}

