#!/usr/bin/env perl6

use lib <lib>;

use Battleship;
use Battleship::Ship;
use Battleship::Player;
use Battleship::AI;
use Battleship::Command;


welcome;

my @ship;

my $human = Battleship::Player.new: name => 'hythm';
my $ai    = Battleship::AI.new:     name => 'ai';

my @player = $human, $ai;

for @player -> $player {

  @ship.append: init-ship( owner => $player.name )

}

my $game = Battleship.new: :@player, :@ship;


#my $i = 2;

loop {

#  my $player = @player[$i++ mod 2];
  my $player = @player[0];

  $game.draw: :$player;

  print 'Now what! > ';

  my $command = $player.command;
  #my $command = 'move Submarine0 west';

  my $m = Battleship::Command.parse( $command, :actions(Battleship::CommandActions) );
  my %command = $m.ast if $m;

  given %command<cmd> {

    when 'move' {

      my $name      = %command<ship>;
      my $direction = %command<direction>;

      my $ship = $game.ship.grep( *.owner eq $player.name ).first( *.name eq $name );
      $ship.move: $direction if $ship;

    }

    when 'fire' {

      my $coords = %command<coords>;

      my $result = $game.check-shot: :$coords;

      if $result ~~ Hit {

        my $ship  = $game.ships.first({ so any(.coords) eqv $coords });
        my $piece = $ship.pieces.first({ .coords eqv $coords });

        $piece.hit   = True;
        $piece.color = 'black';

        say $ship.pieces>>.hit;

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

sub init-ship ( :$owner ) {

  my Battleship::Ship @ship;

  for Frigate, Corvette, Destroyer, Cruiser, Carrier -> $type {

    #my $name = prompt "Enter $type name: ";


    #$name = prompt "Name alredy used, Enter new name: " while %ship{$name};

    @ship.append: Battleship::Ship.new: :$owner, name => $type.Str, :$type;

  }

  @ship;

}

sub welcome ( ) {

  say 'Welcome!';
}
