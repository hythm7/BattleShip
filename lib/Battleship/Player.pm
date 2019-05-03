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

has Channel $.server;
has Channel $.ui;
has Supply  $.events;

method play {

  react {
    whenever $!events {


      when Start {
        $!shots += 1;
        $!server.send: self.command;
      }
      when Hit {

        $!hits += 1;
        self.update-ui;
        $!ui.send: Battleship::Utils::Tweet.new: author => $.name, tweet => 'Yay hit';

      }
      when Miss {
        self.update-ui;
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

method update-ui ( ) {

  $!ui.send: Battleship::Utils::PlayerData.new: :$.name, :$.shots, :$.hits;

}
