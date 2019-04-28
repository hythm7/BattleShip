use Battleship::Utils;
use Battleship::Board;
use Battleship::Server;
use Battleship::AI;
use Battleship::Ship;

unit class Battleship;

has Int    $.x;
has Int    $.y;
has Int    $.ships;
has Int    $.speed;
has Bool   $.hidden;
has Server $!server;
has Player @!player;

submethod BUILD ( Str :$name, Bool :$ai, Int :$!y, Int :$!x, Int :$!ships, Int :$speed, Bool :$hidden ) {

  my $server  = Channel.new;
  my $player1 = Channel.new;
  my $player2 = Channel.new;
  my $play    = $server.Supply;


  $ai ?? @!player.append: AI.new: :$server, events => $player1.Supply, :$speed
      !! @!player.append: Player.new: :$name, :$server, events => $player1.Supply;

  @!player.append: AI.new: :$server, events => $player2.Supply, :$speed, :$hidden;

  my @ship = self.create-ships: :@!player, :$!y, :$!x;
  set-ships-coords :@ship, :$!y, :$!x;

  my $board = Board.new: :$!y, :$!x;

  $!server = Server.new: :$board, :@ship, :$player1, :$player2, :$play;

  start $!server.serve;
  sleep 1;
  start @!player.head.play; 
  sleep 1;
  @!player.tail.play; 

}


submethod create-ships ( ) {

  my @ship;

  for @!player {

    my Bool  $hidden;
    my Color $color;

    $color  = Color.pick;
    #$color  = Color.pick(*).sort.skip(3).head;

    $hidden = .hidden when AI;

    for Frigate, Corvette, Destroyer, Cruiser, Carrier -> $type {
      @ship.append: Ship.new: owner => .name, :$color, :$type, :$hidden;
    }
  }
  @ship;
}

