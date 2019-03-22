use Grid;
use BattleShip::Ship;

enum Fire < Miss Hit >;
enum Direction < North East South West >;

unit class BattleShip;

has Grid             $!grid handles <grid>;
has BattleShip::Ship @!ship;

submethod BUILD ( Int :$x = 10, Int :$y = 10 ) {

  $!grid  = create-grid( grid-x => $x, grid-y => $y );
  
  @!ship.push: BattleShip::Ship.new(Submarine) for ^$x;
  
  self.place-ships;

}

method hunt ( ) {

  my @search-indices = (^$!grid.rows X ^$!grid.columns).grep( -> [$x, $y] { ($x + $y) %% Submarine } );
  
  for @search-indices -> [ $x, $y ] {

    self.target(:$x, :$y, ship => Submarine) if self.fire( :$x, :$y ) ~~ Hit;

  }
}

method target ( Int :$x, Int :$y, :$ship ) {

  say "Found ship at ($x, $y)";

}

method fire ( :$x, :$y --> Fire ) {

  return Hit if $!grid.rotor($!grid.columns)[$x][$y].Str ~~ Pieces.enums;
  return Miss;

}

submethod place-ships () {

  $!grid.rotor($!grid.columns)[ 0; 2, 3, 4 ] = @!ship[0].pieces;
  $!grid.rotor($!grid.columns)[ 1; 3, 4, 5 ] = @!ship[1].pieces;
  $!grid.rotor($!grid.columns)[ 5; 6, 7, 8 ] = @!ship[2].pieces;
  $!grid.rotor($!grid.columns)[ 7; 7, 8, 9 ] = @!ship[3].pieces;
  $!grid.rotor($!grid.columns)[ 1, 2, 3; 0 ] = @!ship[4].pieces;
  $!grid.rotor($!grid.columns)[ 2, 3, 4; 3 ] = @!ship[5].pieces;
  $!grid.rotor($!grid.columns)[ 6, 7, 8; 6 ] = @!ship[6].pieces;
  $!grid.rotor($!grid.columns)[ 7, 8, 9; 2 ] = @!ship[7].pieces;

}


sub create-grid ( Int :$grid-x, Int :$grid-y ) {

  my @g = '.' xx ($grid-x * $grid-y);
  @g does Grid[ columns => $grid-y ];

}

