package me::s0203;
use strict;
use argola;

sub action {
  my @lc_cm;
  
  @lc_cm = ("languamunity001","s003-doit",@_);
  while ( &argola::yet() ) { @lc_cm = (@lc_cm,&argola::getrg()); }
  exec(@lc_cm);
}


1;
