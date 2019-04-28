use Battleship::Play;
use Battleship::Coords;

unit class Battleship::Play::Fire;
  also is Battleship::Play;

has Str                $.play   is required;
has Battleship::Coords $.coords is required;
