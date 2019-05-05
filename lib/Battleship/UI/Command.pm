use Battleship::Utils;
use Terminal::Print::DecodedInput;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Command;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

method TWEAK ( ) {
  self.draw-box(0, 0, $.w - 1, $.h - 1);
  $.grid.set-span-text: 1, 1, '>';

  start self.read-input;
}

method update ( Str :$cmd ) {
  $.grid.clear;
  self.draw-box(0, 0, $.w - 1, $.h - 1);
  $.grid.set-span-text: 1, 1, '>';
  $.grid.set-span-text: 3, 1, $cmd;
  self.composite: :print;
}

method read-input {
  my $input = decoded-input-supply;

  react {
    whenever $input -> $c {
        state $cmd;

        if $c ~~ Str {
            my $char = $c.ord < 32 ?? '^' ~ ($c.ord + 64).chr !! $c;
            #printf "%s", $cmd;
            if $char eq '^M' {
              self.parent.update: data => Battleship::Utils::Tweet.new(author => 'hythm', tweet => $cmd);
              $char = '';
              $cmd = '';
            }

            done if $char eq '^C';

            $cmd ~= $char;
            self.update: :$cmd;
        }
        elsif $c ~~ Terminal::Print::DecodedInput::ModifiedSpecialKey {
            my @mods = ('Meta' if $c.meta), ('Control' if $c.control),
                       ('Alt'  if $c.alt),  ('Shift'   if $c.shift);
            printf "%s", $c.key;
        }
        elsif $c ~~ Terminal::Print::DecodedInput::MouseEvent {
            my @mods    = ('Meta'  if $c.meta), ('Control' if $c.control),
                          ('Shift' if $c.shift);
            my $mods    = @mods ?? " (@mods[])" !! '';
            my $pressed = $c.pressed ?? 'press' !! 'release';
            my $button  = $c.button ?? "button $c.button() $pressed" !! '';
            printf "Mouse: $c.x(),$c.y() { 'motion ' if $c.motion }$button$mods\r\n";
        }
    }
  }

}
