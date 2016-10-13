package me::voca;
use wraprg;
use strict;

my $arcosa;


sub set_arcosa_var {
  $arcosa = $_[0];
}

sub sayit {
  my $lc_cont;
  my $lc_mdv;
  my $lc_cm;
  my $lc_ok;
  my $lc_bg;
  
  if ( !(defined($arcosa->{'stng'}->{'voca'})) ) { return; }
  $lc_ok = 0;
  $lc_bg = 0;
  if ( $arcosa->{'stng'}->{'voca'} eq 'on' ) { $lc_ok = 10; $lc_bg = 10; }
  if ( $arcosa->{'stng'}->{'voca'} eq 'fg' ) { $lc_ok = 10; }
  if ( $lc_ok < 5 ) { return; }
  
  if ( !(defined($_[1])) ) { return; }
  
  $lc_cont = $_[0];
  $lc_mdv = $_[1];
  
  if ( ref($lc_mdv) ne 'HASH' ) { return; }
  
  if ( $lc_mdv->{'typ'} eq 'synth' )
  {
    $lc_cm = 'languamunity';
    &wraprg::lst($lc_cm, ('say--' . $lc_mdv->{'lng'}));
    &wraprg::lst($lc_cm, $lc_mdv->{'gnd'}, $lc_cont);
    
    if ( $lc_bg > 5 )
    {
      $lc_cm .= ' &bg;';
      $lc_cm = '( ' . $lc_cm . ' ) > /dev/null 2> /dev/null';
    }
    
    system($lc_cm);
  }
}



1;
