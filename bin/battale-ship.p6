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

@ship.grep( *.owner eq $human.name ).map( { .visible = True } );

my $game = Battleship.new: :@player, :@ship;


my $player = $game.player[0];

loop {

  #  my $player = @player[0];

  $game.draw;

  print "{$player.name} > ";

  my $command = $player.command;
  #my $command = 'move Submarine0 west';

  my $m = Battleship::Command.parse( $command, :actions(Battleship::CommandActions) );


  if $m {
    $game.update: :$player, command => $m.ast;
  }

  else {
  
    say 'Sorry I did not understand that, try again';

    next;

  }

  $player = @player[$++ mod 2];
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
