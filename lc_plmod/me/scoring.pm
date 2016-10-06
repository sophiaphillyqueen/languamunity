package me::scoring;
use strict;

# A string to identify the mode-format - so as
# to not cause an effectively-infinite delay or
# other major malfunction should things change.
my $modeformat = "2016-1016-a";


sub increment {
  my $lc_con;
  
  $lc_con = &update_raw_score($_[0]);
  $lc_con->{'stat'} = int($lc_con->{'stat'} + 1.2);
  return $lc_con;
}

sub major_timestamp {
  my $lc_now;
  
  $lc_now = `date +%s`; chomp($lc_now);
  $lc_now = int($lc_now / ( 60 * 60 * 26));
  
  return $lc_now;
}

sub new_raw_score {
  my $lc_now;
  my $lc_con;
  
  $lc_now = &major_timestamp();
  
  $lc_con = {
    'when' => $lc_now,
    'stat' => 100,
    'form' => $modeformat,
  };
  
  return $lc_con;
}

sub update_raw_score {
  my $lc_con;
  my $lc_now;
  my $lc_then;
  
  
  $lc_now = &major_timestamp();
  
  $lc_con = $_[0];
  if ( ref($lc_con) ne 'HASH' )
  {
    $lc_con = &new_raw_score();
  }
  
  if ( $lc_con->{'form'} ne $modeformat )
  {
    $lc_con = &new_raw_score();
  }
  
  $lc_then = $lc_con->{'when'};
  while ( $lc_then < $lc_now )
  {
    $lc_con->{'stat'} = int($lc_con->{'stat'} - 0.8);
    $lc_then = int($lc_then + 1.2);
  }
  $lc_con->{'when'} = $lc_then;
  
  return $lc_con;
}


1;
