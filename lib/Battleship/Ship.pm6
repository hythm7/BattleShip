use Battleship::Coords;
use Battleship::Ship::Piece;

enum Name < Turtle Alligator Whale Bass Bonita Shark Seal Salmon Seawolf Tarpon Cuttlefish >;
enum Type ( Submarine => 3, Cruiser => 5, Carrier => 7);
enum State < Swim Sink >;

unit class Battleship::Ship;

has Str   $.name is required;
has Type  $.type is required;
has Piece @.pieces;

has State $!state;

submethod BUILD ( Str :$!name, Type :$!type ) {

  my $shape = ShipPiece.pick;

  @!pieces.append: Piece.new: :$shape for ^$!type;

  $!state = Swim;

}

method coords () {
  @!pieces.map(*.coords);
}
