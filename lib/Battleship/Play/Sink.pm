use Battleship::Play;

unit class Battleship::Play::Sink;
  also is Battleship::Play;

has Str $.play is required;
has Str $.ship is required;
