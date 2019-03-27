#!/usr/bin/env perl6
#
use lib <lib>;

use BattleShip;
use BattleShip::Ship;

my $game = BattleShip.new;
$game.draw;
$game.fire: :7y, :7x;
#$game.hunt;
