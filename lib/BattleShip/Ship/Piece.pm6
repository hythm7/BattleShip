use BattleShip::Coords;

enum ShipPiece < ■ ✗ ✘ ✓ ✔ ‡ ★ ⚜ ☆ □ ♜ ► ◄ △ ▽ ◉ ◎ ☢ ☯ ☣ >;

unit class BattleShip::Ship::Piece;

has Bool               $!hit   = False;
has ShipPiece          $.shape = ShipPiece.roll;
has BattleShip::Coords $.coords;
  

method Str () {
  $!shape.Str;
}
