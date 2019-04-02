#!/usr/bin/env perl6

use lib <lib>;

use Battleship;
use Battleship::Command;

my %conf;



my $game = Battleship.new;

my $human = $game.human;


$game.draw;

loop {


  $game.draw;
  my $command = prompt "> ";;
  #my $command = 'move Submarine0 west';
  #say $command;

  my $m = Battleship::Command.parse( $command, :actions(Battleship::CommandActions) );
  my %command = $m.ast if $m;

  given %command<cmd> {

    when 'move' {

      my $name      = %command<ship>;
      my $direction = %command<direction>;

      my $ship = $human.ship.first({ .name eq $name });
      $ship.move: $direction if $ship;

      sleep 1;

    }

    when 'fire' {

      my $coords = %command<coords>;

      $game.check-shot: :$coords;

    }

    default {

      say 'Sorry I did not understand that, try again';

    }


  }

  #$game.update: :$cmd;


}
