use Battleship::Ship;
use Battleship::Coords;

unit module Battleship::Utils;

enum Event       is export < Start Miss Hit FriendlyFire Collision Escape Won Lost >;
enum Orientation is export < Horizontal Vertical Diagonal >;


class OceanData {
  has @.cell;
}

class PlayerData {
  has $.name;
  has $.shots;
  has $.hits;
}

sub set-ships-coords (:@ship, :$y, :$x ) is export {

  for @ship -> $ship {

    my @coords = rand-coords :@ship, :$y, :$x, type => $ship.type;

    .coords = @coords.shift for $ship.part;

  }

  @ship;
}

sub rand-coords ( :@ship, :$y, :$x, Type :$type, :$orientation = Orientation.roll ) {

  my Battleship::Coords @coords;

  my $randy = (^$y).roll;
  my $randx = (^$x).roll;

  given $orientation {

    #TODO: Random ±

    do @coords.append: Battleship::Coords.new: y => $randy,      x => $randx + $_ for ^$type when Horizontal;
    do @coords.append: Battleship::Coords.new: y => $randy + $_, x => $randx      for ^$type when Vertical;
    do @coords.append: Battleship::Coords.new: y => $randy + $_, x => $randx + $_ for ^$type when Diagonal;
  }

  return @coords if validate-coords :@ship, :$y, :$x, :@coords;

  rand-coords :@ship, :$y, :$x, :$type, :$orientation;
}

sub validate-coords ( :@ship, :$y, :$x, :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$y;
  return False unless all(@coords>>.x) ∈ ^$x;

  so none @coords Xeqv @ship.map(*.coords).flat;

}

