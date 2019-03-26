use BattleShip::Coords;
use BattleShip::Ship::Piece;

enum State < Swim Sink >;
enum ShipType ( Destroyer => 2, Submarine => 3, Cruiser => 4, AircraftCarrier => 5);

unit class BattleShip::Ship;

has Str                     $.name;
has ShipType                $.type;
has BattleShip::Coords      @.coords;
has State                   $!state;
has BattleShip::Ship::Piece @.pieces;


#method new ( Str :$name, ShipType :$type, BattleShip::Coords :@coords ) {

#  self.bless(:$name, :$type, :@coords);

#}

submethod BUILD ( Str :$name, ShipType :$type, BattleShip::Coords :@coords ) {

  $!name = 'ship';

  $!type = $type;

  my $shape = ShipPiece.pick;

  for ^$type {
    #@!pieces.push: BattleShip::Ship::Piece.new(:$shape, ) for ^$type;
    my $coords = @coords.shift;
    my $piece = BattleShip::Ship::Piece.new(:$shape, :$coords);


    @!pieces.push: $piece;
  
  }
  $!state = Swim;

}

method coords () {

  say @!pieces.map(*.coords);

}
