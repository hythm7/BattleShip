unit class Battleship::Server;

has Channel $.player1;
has Channel $.player2;
has Supply  $.action;

method serve {
  my @player = $!player1, $!player2;
  my $player = @player.head;

  react {
    whenever $!action {
      when Battleship::Coords {
      $player.send($!board.cell[.y][.x] ?? Hit !! Miss);

      $player = @player.first( * !=== $player);
      $player.send(Start);
      }
    }

    $player.send(Start);
  }
}
