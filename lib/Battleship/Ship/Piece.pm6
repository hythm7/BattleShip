use Battleship::Coords;

#enum ShipPiece < ■ ✘ ✔ ★ ⚜ ☆ □ ♜ ► ◄ △ ▽ ◉ ◎ ☢ ☯ ☣ >;

unit class Battleship::Ship::Piece;

has Str  $.shape is rw  = '■';
has      $.color is rw;
has Bool $!hit          = False;

has Battleship::Coords $.coords is rw;

method Str ( ) {
  $!shape.Str;
}
