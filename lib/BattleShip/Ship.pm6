use BattleShip::Coords;
use BattleShip::Ship::Piece;

enum State < Swim Sink >;
enum ShipType ( Destroyer => 2, Submarine => 3, Cruiser => 4, AircraftCarrier => 5);

unit class BattleShip::Ship;

has Str                $.name;
has State              $!state;
has Piece              @.pieces;
has ShipType           $.type;
has BattleShip::Coords $.coords is rw;


submethod BUILD ( Str :$name, ShipType :$type = ShipType.roll, BattleShip::Coords :$coords ) {

  $!name = 'ship';

  $!type = $type;
  $!coords = $coords;

  my $shape = ShipPiece.pick;
  @!pieces  = Piece.new( :$shape ) xx $!type;
  
  $!state = Swim;

}

