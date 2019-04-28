use Battleship::Utils;
use Battleship::Ship;

unit class Battleship::Player;

has Str $.name;
has Int $.shots  is rw = 0;
has Int $.hits   is rw = 0;
has Int $.moves  is rw = 0;

has Battleship::Ship @.ship;

has Channel $.server is rw;
has Supply  $.events is rw;

method play {
  react {
    whenever $!events {
      when Start {
        sleep .2;
        $!server.send: Battleship::Coords.new(x => (^10).pick, y => (^10).pick);
      }
      when Hit {
        say "I hit that! +1 gold coin!";
      }
      when Miss {
        say "No, that's a miss... -1 bullet!";
      }
    }
  }
}

method command ( ) {

  $*IN.get;

}
