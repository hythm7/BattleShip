#!/usr/bin/env perl6

use v6;
use Terminal::Print <T>;

# ■
my @a = [ '~' xx 10 ] xx 10;

#.put for @a;

T.initialize-screen;

my $grid = T.current-grid;



$grid.clear;

for ^10 X ^10 -> [$x, $y] {
  $grid.change-cell($x, $y, @a[$x][$y]);  #,,
}
$grid.change-cell(1, 2, '■');
$grid.change-cell(2, 2, '■');
$grid.change-cell(3, 2, '■');
$grid.change-cell(4, 4, '■');
$grid.change-cell(4, 5, '■');
$grid.change-cell(4, 6, '■');
print $grid;

sleep 7;

T.shutdown-screen;

say $grid.columns;
