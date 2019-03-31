#!/usr/bin/env perl6
#
use lib <lib>;
use Battleship::Command;

my $command = 'f 42, 7';
my $actions = Battleship::CommandActions;
my $m =  Battleship::Command.parse: $command, :$actions;

say $m.ast;
