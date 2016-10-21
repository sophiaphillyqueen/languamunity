package me::distress;
use strict;
use chobak_jsio;
use me::valus;
use chobaktime;

my $arcosa;

sub set_arcosa_var {
  $arcosa = $_[0];
}


sub trpcmd {
  my $lc_cmd;
  my $lc_bgin;
  
  # Of course, the first round (as identified by the empty string)
  # we do nothing but return -true- with the '*' value as the
  # temporary value:
  if ( $_[0] eq '' )
  {
    $_[0] = '*';
    return(2 > 1 );
  }
  
  # First, we input the value and save it to
  # the call-by-reference argument
  $lc_cmd = &chobak_jsio::inln();
  $_[0] = $lc_cmd;
  
  # Now we find the tell-tale string-beginning
  $lc_bgin = substr $lc_cmd, 0 , 2;
  return ( $lc_bgin eq '**' );
}

sub mortcalc {
  my $lc_now;
  my $lc_then;
  
  $lc_now = &chobaktime::nowo();
  $lc_then = $_[0];
  
  if ( $lc_then > ( $lc_now + 300 ) ) { return(1>2); }
  if ( $lc_then < ( $lc_now - ( 60 * 60 * &me::valus::look('mortality-hours') ) ) ) { return(1>2); }
  
  # This next litany is there so that I can manually decide
  # to effectively clear-out all mortal flashcards.
  if ( defined($arcosa->{'stng'}->{'mort'}) )
  {
    if ( $lc_then < ($arcosa->{'stng'}->{'mort'}) ) { return(1>2); }
  }
  
  return(2>1);
}


1;
