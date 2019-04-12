use Terminal::ANSIColor;
use Battleship::Ship;

unit class Board;

my class Cell {

  constant water      = '~';

  has Str   $.sym    = water;
  has Color $.color  = cyan;
  has Bool  $.hidden = False;

  method Str ( ) {

    return colored(water, ~cyan) if $!hidden;
    return colored($!sym, $!color.Str);
  }
}


has $.y;
has $.x;
has @.cell;

method place-ships ( Battleship::Ship :@ship ) {

  self.clear;

  for @ship -> $ship {

    @!cell[.coords.y][.coords.x] = Cell.new(
      sym => .shape, color => .color, hidden => .hidden ) for $ship.part;
  }
}

method draw ( ) {

  .put for @!cell;

}

method clear ( ) {

  @!cell = [ [ Cell.new xx $!y ] xx $!x ];

}


