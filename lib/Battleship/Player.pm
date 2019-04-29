use Battleship::Utils;
use Battleship::Play;
use Battleship::Ship;
use Battleship::Command;

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
        $!server.send: self.command;
      }
      when Hit {
        #say "I hit that! +1 gold coin!";
      }
      when Miss {
        #say "No, that's a miss... -1 bullet!";
      }
      when Won {
        done;
      }
      when Lost {
        done;
      }
    }
  }
}

method command ( --> Battleship::Play ) {

  print 'Sorry I did not understand that, try again > '
  until my $play = Battleship::Command.parse( get, actions => Command::Actions.new(:$!name) ).ast;

  $play;

}
