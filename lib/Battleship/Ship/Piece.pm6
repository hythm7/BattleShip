use Battleship::Coords;

enum ShipPiece < ■ ✘ ✔ ★ ⚜ ☆ □ ♜ ► ◄ △ ▽ ◉ ◎ ☢ ☯ ☣ >;

unit class Battleship::Ship::Piece;

has ShipPiece          $.shape = ShipPiece.roll;
has Battleship::Coords $.coords is rw;
has Bool               $!hit   = False;
  

method Str ( ) {
  $!shape.Str;
}
