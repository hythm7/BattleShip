use Battleship::Play;

unit class Battleship::Play::Move;
  also is Battleship::Play;

has Str $.play      is required; 
has Str $.ship      is required;
has Str $.direction is required;
