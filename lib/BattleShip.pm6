use Grid;
use BattleShip::ShipFactory;
use BattleShip::Ship;

unit class BattleShip;

has Grid         $!grid handles <grid>;
has Battle::Ship @!ship;

submethod BUILD ( Int :$x = 10, Int :$y = 10 ) {

  $!grid = create-grid( grid-x => $x, grid-y => $y );
  self.place-ships;

}

method hunt ( $ship ) {

  my @search-indices = ($!grid.rows X $!grid.columns).grep( -> [$x, $y] { ($x + $y) %% $ship.dimensio } )



}


submethod place-ships ( ) {
  $!grid[  2,  3,  4 ] = '▬' xx 3 ;
  $!grid[ 13, 14, 15 ] = '▬' xx 3 ;
  $!grid[ 56, 57, 58 ] = '▬' xx 3 ;
  $!grid[ 77, 78, 79 ] = '▬' xx 3 ;

  $!grid[ 10, 20, 30 ] = '▮' xx 3 ;
  $!grid[ 23, 33, 43 ] = '▮' xx 3 ;
  $!grid[ 66, 76, 86 ] = '▮' xx 3 ;
  $!grid[ 72, 82, 92 ] = '▮' xx 3 ;

}


sub create-grid ( Int :$grid-x, Int :$grid-y ) {

  my @g = '.' xx ($grid-x * $grid-y);
  @g does Grid[ columns => $grid-y ];

}

