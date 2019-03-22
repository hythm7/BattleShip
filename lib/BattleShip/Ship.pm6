
enum State < Swim Sink >;
enum Type ( Destroyer => 2, Submarine => 3, Cruiser => 4, AircraftCarrier => 5);
enum Pieces < ■ ✗ ✘ ✓ ✔ ‡ ★ ⚜ ☆ □ ♜ ► ◄ △ ▽ ◉ ◎ ☢ ☯ ☣ >;

unit class BattleShip::Ship;

my class Piece {

  has Bool   $!hit  = False;
  has Pieces $.shape = Pieces.roll;
  
  method Str () {
    $!shape.Str;
  }

}

has Type   $.type;
has State  $.state;
has Piece  @.pieces;


method new ( Type $type ) {

  self.bless(:$type);

}

submethod BUILD ( :$type ) {

  $!type = $type;
  
  my $shape = Pieces.pick;
  @!pieces.push: Piece.new(:$shape) for ^$type;
  
  $!state = Swim;

}

