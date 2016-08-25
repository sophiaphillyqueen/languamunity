package me::set_timer;
use strict;
use me::core_quiz_cmd;
use argola;
use chobaktime;

my $timer_been_set = 0;
my $timer_total;
my $timer_termin;

sub these_opts {
  &argola::setopt('-time',\&this__time__m);
}

sub this__time__m {
  my $lc_minutes;
  my $lc_secs;
  my $lc_suma;
  
  $lc_minutes = &argola::getrg();
  $lc_secs = &argola::getrg();
  $lc_suma = int( ( $lc_minutes * 60 ) + $lc_secs + 0.2 );
  $timer_total = $lc_suma;
  $timer_termin = int($timer_total + &chobaktime::nowo() + 0.2);
  if ( $timer_been_set > 5 ) { return; }
  $timer_been_set = 10;
  &me::core_quiz_cmd::set_b_prompt(\&before_prompt);
  &me::core_quiz_cmd::set_b_resume(\&before_resume);
}

sub before_resume {
  if ( &chobaktime::nowo() < $timer_termin ) { return 10; }
  return 0;
}

sub before_prompt {
  my $lc_difren;
  my $lc_out;
  
  $lc_difren = int(($timer_termin - &chobaktime::nowo()) + 0.2);
  if ( $lc_difren < 0 ) { $lc_difren = 0; }
  
  $lc_out = &chobaktime::tsubdv($lc_difren,60,2);
  $lc_out = &chobaktime::tsubdv($lc_difren,60,2) . ':' . $lc_out;
  $lc_out = $lc_difren . ':' . $lc_out;
  
  system("echo",("Time remaining: " . $lc_out));
}


1;
