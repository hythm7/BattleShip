#!/usr/bin/env perl6

use lib <lib>;

use Battleship;

multi MAIN ( Int :$y = 20, Int :$x = 20 ,Int :$ships = 10, Int :$speed = 4, Bool :$hidden ) {

welcome;

my $name = prompt 'Enter player name: ';

my $game = Battleship.new: :$name, :$y, :$x, :$ships, :$speed, :$hidden;

}

multi MAIN ( Bool :$ai!, Int :$y = 20, Int :$x = 20, Int :$ships = 10, Int :$speed = 4, Bool :$hidden ) {

welcome;

my $game = Battleship.new: :$ai, :$y, :$x, :$ships, :$speed, :$hidden;

}

sub welcome ( ) {

  say 'Welcome!';
}
