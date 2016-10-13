package me::voca;
use strict;

sub sayit {
  my $lc_cont;
  my $lc_mdv;
  my @lc_cm;
  
  if ( !(defined($_[1])) ) { return; }
  
  $lc_cont = $_[0];
  $lc_mdv = $_[1];
  
  if ( ref($lc_mdv) ne 'HASH' ) { return; }
  
  if ( $lc_mdv->{'typ'} eq 'synth' )
  {
    @lc_cm = ('languamunity');
    @lc_cm = (@lc_cm, ('say--' . $lc_mdv->{'lng'}));
    @lc_cm = (@lc_cm, $lc_mdv->{'gnd'}, $lc_cont);
    
    system(@lc_cm);
  }
}



1;
