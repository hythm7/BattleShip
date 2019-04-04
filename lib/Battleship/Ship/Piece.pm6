use Battleship::Coords;

#enum ShipPiece < ■ ✘ ✔ ★ ⚜ ☆ □ ♜ ► ◄ △ ▽ ◉ ◎ ☢ ☯ ☣ >;

unit class Battleship::Ship::Piece;

has Str  $.shape is rw  = '■';
has Str  $.color is rw;
has Bool $.hit   is rw  = False;

has Battleship::Coords $.coords is rw;

method Str ( ) {
  $!shape.Str;
}

