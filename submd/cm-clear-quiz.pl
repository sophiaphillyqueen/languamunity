use strict;
use argola;
use me::longterm;

# This sub-command is written just in case there is a
# need to clear both the hand and the deck in the current
# quiz.

my $arcosa;
my $dlt_missed = 10;

$arcosa = &me::longterm::load();

sub opto__f_do {
  $arcosa = &me::longterm::load_quiz_file(&argola::getrg());
} &argola::setopt('-f',\&opto__f_do);

sub opto__pmiss_do {
  $dlt_missed = 0;
} &argola::setopt('-pmiss',\&opto__pmiss_do);

&argola::runopts();


$arcosa->{'queue'} = [];
$arcosa->{'deck'} = [];
$arcosa->{'hnd01'} = [];
$arcosa->{'hnd02'} = [];
$arcosa->{'hnd03'} = [];
$arcosa->{'mtdeck'} = [];

# All records of deck graduation go as well:
$arcosa->{'gradrec'} = [];

if ( $dlt_missed > 5 )
{
  $arcosa->{'redeck'} = [];
  $arcosa->{'rehand'} = [];
}

$arcosa->{'hand'} = [];
$arcosa->{'names'} = {};
$arcosa->{'inrc'} = {};


&me::longterm::save($arcosa);


