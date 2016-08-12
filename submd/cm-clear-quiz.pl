use strict;
use me::longterm;

# This sub-command is written just in case there is a
# need to clear both the hand and the deck in the current
# quiz.

my $arcosa;

$arcosa = &me::longterm::load();

$arcosa->{'queue'} = [];
$arcosa->{'deck'} = [];
$arcosa->{'hand'} = [];


&me::longterm::save($arcosa);


