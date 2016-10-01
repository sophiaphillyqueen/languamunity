use strict;
use me::longterm;
use argola;
use chobak_json;
use chobak_cstruc;
use me::extrac;
use me::core_take_cmd;
use me::tally_basics;

my $arcosa;
my $deckref;
my @inpfiles = ();
my $eachfile;
my $quizfset = 0;
my $quizfloc;

sub opt__in__on {
  @inpfiles = (@inpfiles,&argola::getrg());
} &argola::setopt('-in',\&opt__in__on);

sub opt__to__on {
  $quizfloc = &argola::getrg();
  $quizfset = 10;
} &argola::setopt('-to',\&opt__to__on);


&argola::runopts();


if ( $quizfset < 5 ) { $arcosa = &me::longterm::load(); }
else { $arcosa = &me::longterm::load_quiz_file($quizfloc); }


&me::core_take_cmd::set_arcosa_var($arcosa);

$deckref = $arcosa->{'deck'};
foreach $eachfile ( @inpfiles )
{
  &me::core_take_cmd::one_round($eachfile);
}


&me::tally_basics::shift_unasked_in_arcos($arcosa);
&me::longterm::save($arcosa);





