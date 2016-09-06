use strict;
use me::longterm;
use me::core_quiz_cmd;
use me::set_timer;
use argola;

my $arcosa;
my $qsstart;
my $qsend;
my $qsadv;

me::set_timer::these_opts();

&argola::runopts();



$arcosa = &me::longterm::load();

$qsstart = &findstat();
sub findstat {
  my $lc_a;
  my $lc_b;
  my $lc_c;
  $lc_a = &chobak_cstruc::counto($arcosa->{'hand'});
  $lc_b = &chobak_cstruc::counto($arcosa->{'deck'});
  $lc_c = int($lc_a + $lc_b + 0.2);
  return $lc_c;
}

&me::core_quiz_cmd::set_arcosa_var($arcosa);



while ( &me::core_quiz_cmd::anotround() ) { &me::core_quiz_cmd::enter_the_prompt(); }

system("clear");

$qsend = &findstat();

&me::longterm::save($arcosa);

$qsadv = int(($qsstart - $qsend) + 0.2);

system("echo",("  START QUIZ-SIZE: " . $qsstart));
system("echo",("    END QUIZ-SIZE: " . $qsend));
system("echo",("NET CARDS CLEARED: " . $qsadv));



