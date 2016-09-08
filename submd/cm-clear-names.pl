use strict;
use me::longterm;
use argola;

# This sub-command is written just in case there is a
# need to clear both the hand and the deck in the current
# quiz.

my $arcosa;
my $quiz_f_loc;
my $quiz_f_set = 10;

sub opto__f__do {
  $quiz_f_loc = &argola::getrg();
  $quiz_f_set = 10;
} &argola::setopt('-f',\&opto__f__do);

&argola::runopts();

if ( $quiz_f_set > 5 ) { &me::longterm::load_quiz_file($quiz_f_loc); }
else { $arcosa = &me::longterm::load(); }

$arcosa->{'names'} = {};
$arcosa->{'inrc'}->{'nameid'} = 0;


&me::longterm::save($arcosa);


