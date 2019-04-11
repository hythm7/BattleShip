use Terminal::ANSIColor;
use Battleship::Ship;

unit class Board;

my class Cell {

  constant WATER      = '~';
  constant WATERCOLOR = 'cyan';

  has Str  $.sym    = WATER;
  has Str  $.color  = WATERCOLOR;
  has Bool $.hidden = False;

  method Str ( ) {

    return colored(WATER, WATERCOLOR) if $!hidden;

    return colored($!sym, $!color);
  }
}


has $.y;
has $.x;
has @.cell;

#method new ( Int :$y, Int :$x ) {


#    my @values = [ [ Cell.new xx $y ] xx $x ];


        #nextwith(|@values);

        #}
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


