#!/usr/bin/env perl6
#
use lib <lib>;
use Battleship::Command;

my $command = 'move submarine right';
my $actions = Battleship::CommandActions;
my $m =  Battleship::Command.parse: $command, :$actions;

say $m.ast;
