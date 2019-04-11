#!/usr/bin/env perl6

use lib <lib>;

use Battleship;

multi MAIN ( Int :$y = 20, Int :$x = 20 ,Int :$ships = 10, Int :$speed = 4 ) {

welcome;

my $name = prompt 'Enter player name: ';

my $game = Battleship.new: :$name, :$y, :$x, :$ships, :$speed;


$game.run;

}

multi MAIN ( Bool :$ai!, Int :$y = 20, Int :$x = 20, Int :$ships = 10, Int :$speed = 4, :$hidden = False ) {

welcome;


my $game = Battleship.new: :$ai, :$y, :$x, :$ships, :$speed, :$hidden;


$game.run;

}

sub welcome ( ) {

  say 'Welcome!';
}
