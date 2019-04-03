#!/usr/bin/env perl6

use lib <lib>;

use Battleship;
use Battleship::Ship;
use Battleship::Player;
use Battleship::AI;
use Battleship::Command;


welcome;


my $human = init-player;
my $ai    = Battleship::AI.new;

my @player = $human, $ai;

my $game = Battleship.new: :@player;


my $i = 2;

loop {

  my $player = @player[$i++ mod 2];
#  my $player = @player[0];


      $game.draw: :$player;
      my $command = prompt "> ";;
      #my $command = 'move Submarine0 west';
      #say $command;

      my $m = Battleship::Command.parse( $command, :actions(Battleship::CommandActions) );
      my %command = $m.ast if $m;

      given %command<cmd> {

        when 'move' {

          my $name      = %command<ship>;
          my $direction = %command<direction>;

          my $ship = $player.ship.first({ .name eq $name });
          $ship.move: $direction if $ship;

        }

        when 'fire' {

          my $coords = %command<coords>;

          my $result = $game.check-shot: :$coords;

          if $result ~~ Hit {

            my $ship = $game.ships.first({ so any(.coords) eqv $coords });
            say $ship.pieces.first({ .coords eqv $coords }).hit ;

          }

          else {
            say 'you missed!';
          }

        }

        default {

          say 'Sorry I did not understand that, try again';

        }



    }  #$game.update: :$cmd;

}

sub init-player ( ) {

  #my $name = prompt "Enter player name: ";
  my $name = 'hythm';

  my Battleship::Ship @ship;

  for Submarine, Submarine, Cruiser, Cruiser, Carrier -> $type {

    my @names = < s1 s2 c1 c2 c >;
    my $name = @names[$++];
    #my $name = prompt "Enter $type name: ";

    #$name = prompt "Name alredy used, Enter new name: " while %ship{$name};

    @ship.append: Battleship::Ship.new: :$name, :$type;

  }

  Battleship::Player.new: :$name, :@ship;

}

sub welcome ( ) {

  say 'Welcome!';
}
