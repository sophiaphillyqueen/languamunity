use strict;
use me::longterm;
use me::core_quiz_cmd;
use me::set_timer;
use me::tally_basics;
use chobak_cstruc;
use argola;
use chobaktime;
use me::valus;

my $arcosa;
my $qsstart;
my $qsend;
my $qsadv;
my $qfile_set = 0;
my $qfile_val;
my $numof_oops;
my $numof_rqst;
my $stat_in_round;
my $time_begin;
my $time_finish;

&me::set_timer::these_opts();

&me::tally_basics::cusv_set('oops',0);
&me::tally_basics::cusv_set('rqst',0);
&me::tally_basics::cusv_set('dam',&me::valus::look('dfl-dam-height'));

sub opto__dam__do {
  &me::tally_basics::cusv_set('dam',&argola::getrg());
} &argola::setopt('-dam',\&opto__dam__do);

sub opto__quizfile__do {
  $qfile_val = &argola::getrg();
  $qfile_set = 10;
} &argola::setopt('-quizfile',\&opto__quizfile__do);

&argola::runopts();


$time_begin = &chobaktime::nowo();


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

# Capture the moment that the quiz ends:
$time_finish = &chobaktime::nowo();

system("echo",("        Start time: " . &chobaktime::nm_normdate($time_begin)));
system("echo",("          End time: " . &chobaktime::nm_normdate($time_finish)));
system("echo",("Round Within Level: " . &chobak_cstruc::counto($arcosa->{'gradrec'})));
system("echo",("   Status In Round: " . $stat_in_round));
system("echo",("   START QUIZ-SIZE: " . $qsstart));
system("echo",("     END QUIZ-SIZE: " . $qsend));
system("echo",("     Wrong Answers: " . $numof_oops));
system("echo",("Rehashes Requested: " . $numof_rqst));
system("echo",(" NET CARDS CLEARED: " . $qsadv));


# ########################## #
# ##  SAVE THIS HISTORY:  ## #
# ########################## #

&chobak_cstruc::ry_push($arcosa->{'pastuse'},{
  'start' => $time_begin,
  'stop' => $time_finish,
  'round' => &chobak_cstruc::counto($arcosa->{'gradrec'}),
});
&maybe_skim(); sub maybe_skim {
  my $lc_now;
  my $lc_dawnof;
  
  # Don't purge if that would bring the number of records down below five
  if ( &chobak_cstruc::counto($arcosa->{'pastuse'}) < 6.5 ) { return; }
  
  # Don't purge if the second-oldest record is less than eight days old.
  $lc_now = &chobaktime::nowo();
  $lc_dawnof = int(($lc_now - (60 * 60 * 24 * 8)) + 0.2);
  if ( $lc_dawnof < $arcosa->{'pastuse'}->[1]->{'stop'} ) { return; }
  
  # If permitted to, though, we purge the oldest two records.
  &chobak_cstruc::ry_shift($arcosa->{'pastuse'});
  &chobak_cstruc::ry_shift($arcosa->{'pastuse'});
}
&me::longterm::save($arcosa);



