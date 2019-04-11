use Battleship::Command;
use Battleship::Board;
use Battleship::AI;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Orientation < Horizontal Vertical Diagonal >;


unit class Battleship;

has Int    $!x;
has Int    $!y;
has Int    $!ships;
has Board  $!board;
has Ship   @.ship;
has Player @.player[2];

multi method new ( Str :$name!, Int :$y!, Int :$x!, Int :$ships!, Int :$speed!, Bool :$hidden ) {

  my Player @player;

  my $player1 = Player.new: :$name;
  my $player2 = AI.new: board-y => $y, board-x => $x, :$speed, :$hidden;

  @player.append: $player1, $player2;

  self.bless( :@player, :$y, :$x, :$ships )

}

multi method new ( Bool :$ai!, Int :$y!, Int :$x!, Int :$ships!, Int :$speed!, Bool :$hidden! ) {

  my Player @player;

  my $player1 = AI.new: board-y => $y, board-x => $x, :$speed;
  my $player2 = AI.new: board-y => $y, board-x => $x, :$speed, :$hidden;

  @player.append: $player1, $player2;

  self.bless( :@player, :$y, :$x, :$ships )

}


submethod BUILD ( Player :@!player, Int :$!y, Int :$!x, Int :$!ships ) {

  self.create-ships;
  self.set-ships-coords;

  $!board = Board.new: :$!y, :$!x;
  $!board.place-ships: :@!ship;

  self.draw;

}


method draw ( ) {

  say '';
  #clear;

  $!board.draw;

  say '';
  say '';

  for @!player {

    say "{.name}:";
    say "shots {.shots} hits {.hits} moves {.moves}";
    say '';

  }
}

method check-shot ( Coords :$coords --> Fire ) {

  my $sym = $!board.cell[$coords.y][$coords.x].sym;

  return Hit if  $sym eq '■';
  return Miss;
}


submethod create-ships ( Player :$player ) {

  for @!player {

    my Bool  $hidden;
    my Color $color;

    $color  = Color.pick;
    $hidden = .hidden        when AI;

    for Frigate, Corvette, Destroyer, Cruiser, Carrier -> $type {
      @!ship.append: Ship.new: owner => .name, :$color, :$type, :$hidden;
    }
  }
}

submethod set-ships-coords ( ) {

  for @!ship -> $ship {

    my @coords = self.rand-coords: type => $ship.type;

    .coords = @coords.shift for $ship.part;

  }



}

submethod rand-coords ( Type :$type, Orientation :$orientation = Orientation.roll ) {

  my Battleship::Coords @coords;

  my $y = (^$!y).roll;
  my $x = (^$!x).roll;

  given $orientation {

    #TODO: Random ±

    do @coords.append: Coords.new: y => $y,      x => $x + $_ for ^$type when Horizontal;
    do @coords.append: Coords.new: y => $y + $_, x => $x      for ^$type when Vertical;
    do @coords.append: Coords.new: y => $y + $_, x => $x + $_ for ^$type when Diagonal;
  }

  return @coords if self.validate-coords: :@coords;

  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$!y;
  return False unless all(@coords>>.x) ∈ ^$!x;

  so none @coords Xeqv @!ship.map(*.coords).flat;

}

method welcome ( ) {

  say 'Welcome!';

}


submethod process-command ( :$player, :%command ) {

  given %command<action> {

    when 'move' {

      $player.moves += 1;

      my $name      = %command<ship>;
      my $direction = %command<direction>;

      my $ship = @!ship.grep( *.owner eq $player.name ).first( *.name eq $name );
      $ship.move: $direction if $ship;


    }

    when 'fire' {

      $player.shots += 1;

      my $coords = %command<coords>;
      my $result = self.check-shot: :$coords;

      if $result ~~ Hit {

        $player.hits += 1;

        my $ship  = @!ship.first({ so any(.coords) eqv $coords });
        my $part = $ship.part.first({ .coords eqv $coords });

        $part.hit   = True;
        $part.color = black;
      }
    }
  }

}

submethod update ( ) {

  $!board.place-ships: :@!ship;
}

method run ( ) {

  loop {

    my $player = @!player[$++ mod 2];

    print "{$player.name} > ";

    print 'Sorry I did not understand that, try again > '
      until my $command = Command.parse( $player.command, actions => Actions ).ast;

    self.process-command: :$player, :$command;
    self.update;
    self.draw;

  }

}

sub clear { print qx[clear] }
