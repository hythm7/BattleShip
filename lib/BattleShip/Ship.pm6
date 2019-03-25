use BattleShip::Coords;
use BattleShip::Ship::Piece;

enum State < Swim Sink >;
enum ShipType ( Destroyer => 2, Submarine => 3, Cruiser => 4, AircraftCarrier => 5);

unit class BattleShip::Ship;

has ShipType                $.type;
has State                   $.state;
has BattleShip::Ship::Piece @.pieces;
has BattleShip::Coords      $.coords;


method new ( ShipType $type ) {

  self.bless(:$type);

}

submethod BUILD ( ShipType :$type ) {

  $!type = $type;
  
  my $shape = ShipPiece.pick;
  @!pieces.push: BattleShip::Ship::Piece.new(:$shape) for ^$type;
  
  $!state = Swim;

}

method coords () {

  @!pieces.map(*.coords);

}
