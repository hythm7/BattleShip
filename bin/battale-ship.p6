#!/usr/bin/env perl6
#
use lib <lib>;

use Battleship;
use Battleship::Ship;

my $game = Battleship.new;
$game.draw;
#$game.fire: :7y, :7x;
#$game.hunt;
