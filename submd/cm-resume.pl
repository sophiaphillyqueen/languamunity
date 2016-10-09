use strict;
use me::longterm;
use me::core_quiz_cmd;
use me::set_timer;
use me::tally_basics;
use chobak_cstruc;
use argola;

my $arcosa;
my $qsstart;
my $qsend;
my $qsadv;
my $qfile_set = 0;
my $qfile_val;
my $numof_oops;
my $numof_rqst;
my $stat_in_round;

&me::set_timer::these_opts();

&me::tally_basics::cusv_set('oops',0);
&me::tally_basics::cusv_set('rqst',0);

sub opto__quizfile__do {
  $qfile_val = &argola::getrg();
  $qfile_set = 10;
} &argola::setopt('-quizfile',\&opto__quizfile__do);

&argola::runopts();


if ( $qfile_set > 5 ) { $arcosa = &me::longterm::load_quiz_file($qfile_val); }
else { $arcosa = &me::longterm::load(); }

$qsstart = &findstat();
sub findstat {
  my $lc_a;
  my $lc_odck;
  my $lc_odcv;
  $lc_a = 0;
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'hand'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'deck'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'rehand'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'redeck'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'hnd01'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'hnd02'}) + $lc_a + 0.2);
  $lc_a = int( &chobak_cstruc::counto($arcosa->{'hnd03'}) + $lc_a + 0.2);
  $lc_odck = $arcosa->{'mtdeck'};
  foreach $lc_odcv (@$lc_odck)
  {
    $lc_a = int( &chobak_cstruc::counto($lc_odcv) + $lc_a + 0.2);
  }
  return $lc_a;
}

&me::core_quiz_cmd::set_arcosa_var($arcosa);



while ( &me::core_quiz_cmd::anotround() ) { &me::core_quiz_cmd::enter_the_prompt(); }

system("clear");

$qsend = &findstat();

&me::longterm::save($arcosa);

$numof_oops = &me::tally_basics::cusv_get('oops');
$numof_rqst = &me::tally_basics::cusv_get('rqst');

$qsadv = int(($qsstart - $qsend) + 0.2);
if ( $qsend > $qsstart ) { $qsadv = int($qsadv - 1.2); }

# Generate the report-string for the within-the-round status
$stat_in_round = &chobak_cstruc::counto($arcosa->{'rehand'});
$stat_in_round .= ':' . &chobak_cstruc::counto($arcosa->{'redeck'});
$stat_in_round .= ' - ' . &chobak_cstruc::counto($arcosa->{'hand'});

system("echo",("   Status In Round: " . $stat_in_round));
system("echo",("   START QUIZ-SIZE: " . $qsstart));
system("echo",("     END QUIZ-SIZE: " . $qsend));
system("echo",("     Wrong Answers: " . $numof_oops));
system("echo",("Rehashes Requested: " . $numof_rqst));
system("echo",(" NET CARDS CLEARED: " . $qsadv));



