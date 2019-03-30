use Battleship::Player;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Direction   < North East South West >;
enum Orientation < Horizontal Vertical Diagonal >;


unit class Battleship;

has Int    $.x;
has Int    $.y;
has Int    $.count;
has        @!board;
has Ship   @!ships;
has Player $.human;


submethod BUILD ( Int :$!y = 20, Int :$!x = 20 ) {

  # welcome
  # init board
  # print board
  # init player
  # place ships
   
  self.welcome;

  @!board = self.init-board;

  $!human = self.init-player;

  @!ships = $!human.ship.values;

  self.place-ships;


  self.draw;

  #  self.place-ships;

}


method draw () {

  for @!ships -> $ship {

    @!board[.coords.y][.coords.x] = .shape for $ship.pieces;

  }

  .put for @!board;

}


method fire ( :$y!, :$x! --> Fire ) {

  if @!board[$y; $x] ~~ Ship::Piece {

    my $ship =  @!ships.first({ $y ∈ .coords.y and $x ∈ .coords.x });
    say "You hit { $ship.type } { $ship.name } at ($y, $x)!";
  }

  return Miss;

}



submethod place-ships () {

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

method init-board ( ) {

  [ '~' xx $!y ] xx $!x;

}

method init-player ( ) {

  #my $name = prompt "Enter player name: ";
  my $name = 'hythm';

  my Ship %ship;

  for Submarine, Submarine, Cruiser, Cruiser, Carrier -> $type {

    my $name = $type.Str ~ $++;
    #my $name = prompt "Enter $type name: ";

    #$name = prompt "Name alredy used, Enter new name: " while %ship{$name};    

    %ship{$name} = Ship.new: :$name, :$type;

  }

  $!human = Player.new: :$name, :%ship;

}
