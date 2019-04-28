use Battleship::Utils;
use Battleship::Command;
use Battleship::Coords;
use Battleship::Board;
use Battleship::AI;
use Battleship::Ship;

unit class Battleship::Server;

has Battleship::Ship @.ship;
has Board            $.board;
has Channel          $.player1;
has Channel          $.player2;
has Supply           $.action;

submethod TWEAK ( ) {
  $!board.place-ships: :@!ship;
}

method serve ( ) {

  my @player = $!player1, $!player2;
  my $player = @player.head;

  react {
    whenever $!action {
      when Battleship::Coords {
      $player.send($!board.cell[.y][.x].sym ~~ '■' ?? Hit !! Miss);

      $player = @player.first( * !=== $player);
      $player.send(Start);
      }
    }

    $player.send(Start);
  }
}

submethod update ( ) {

  $!board.place-ships: :@!ship;
  last if [eq] @!ship.map(*.owner);
}

multi method command ( :$action where move, Str :$name, Direction :$direction, :$player ) {

      $player.moves += 1;

      my $ship = @!ship.grep( *.owner eq $player.name ).first( *.name eq $name );
      $ship.move: $direction if $ship;
}

multi method command ( :$action where fire, :$coords, :$player ) {

  $player.shots += 1;

  my $result = self.check-shot: :$coords;

  if $result ~~ Hit {

    $player.hits += 1;

    my $ship  = @!ship.first({ so any(.coords) eqv $coords });
    my $part = $ship.part.first({ .coords eqv $coords });

    $part.hit   = True;
    $part.color = black;

    @!ship .= grep: not * eqv $ship if all $ship.part.map(*.hit);
  }
}


method draw ( ) {

  say '';
  # clear;

  $!board.draw;

  say '';
  say '';

  }

method check-shot ( Battleship::Coords :$coords --> Fire ) {

  my $sym = $!board.cell[$coords.y][$coords.x].sym;

  return Hit if  $sym eq '■';
  return Miss;
}

sub clear { print qx[clear] }
