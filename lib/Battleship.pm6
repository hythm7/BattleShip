use Terminal::ANSIColor;
use Battleship::Player;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Orientation < Horizontal Vertical Diagonal >;

constant WATER = colored('~', 'cyan');

unit class Battleship;

has Int    $.x;
has Int    $.y;
has Int    $.count;
has        @!board;
has Ship   @.ships;
has Player @.player[2];


submethod BUILD ( Int :$!y = 20, Int :$!x = 20, :@!player ) {

  # welcome
  # init board
  # print board
  # init player
  # place ships

  #$!human = self.init-player;

  @!ships = @!player.map(*.ship).flat;

  self.place-ships;

  #self.draw;

  #loop {

  #  my $cmd = self.read-command;

  #  self.update: :$cmd;
  #  self.draw;
  #}

}


method draw ( :$player ) {

  self.clear-board;

  for $player.ship -> $ship {

    @!board[.coords.y][.coords.x] = .shape for $ship.pieces;

  }
  
  #clear;

  .join.put for @!board;

}


submethod update ( :$cmd ) {


}

method check-shot ( Coords :$coords --> Fire ) {

  say @!board[$coords.y][$coords.x];
  if colorstrip @!board[$coords.y][$coords.x] eq '■' {

    my $ship =  @!ships.first({ .coords eqv $coords });
    say "You hit { $ship.type } { $ship.name } at ($coords.y, $coords.x)!";
  }

  say Miss;
  return Miss;

}



submethod place-ships ( ) {

  for @!ships -> $ship {

    my @coords = self.rand-coords: type => $ship.type;

    .coords = @coords.shift for $ship.pieces;

  }

}

submethod rand-coords ( Type :$type, Orientation :$orientation = Orientation.roll ) {

  my Battleship::Coords @coords;

  my $y = (^$!y).roll;
  my $x = (^$!x).roll;

  given $orientation {

    #TODO: Random ±

    do @coords.append: Coords.new: y => $y,      x => $x + $_ for ^$type when Horizontal;
    do @coords.append: Coords.new: y => $y + $_, x => $x      for ^$type when Vertical;
    do @coords.append: Coords.new: y => $y + $_, x => $x + $_ for ^$type when Diagonal;
  }

  return @coords if self.validate-coords: :@coords;

  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$!y;
  return False unless all(@coords>>.x) ∈ ^$!x;

  so none @coords Xeqv @!ships.map(*.coords).flat;

}

method welcome ( ) {

  say 'Welcome!';

}

method clear-board ( ) {

  @!board = [ WATER xx $!y ] xx $!x;

}

sub clear { print qx[clear] }
