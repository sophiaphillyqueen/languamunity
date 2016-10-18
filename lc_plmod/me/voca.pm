package me::voca;
use wraprg;
use strict;

my $arcosa;

my $qas_string;
my $qas_spspec;
my $qas_params;

my $was_string;
my $was_spspec;
my $was_params;


sub set_arcosa_var {
  $arcosa = $_[0];
}

sub aprosay {
  my $lc_cm;
  if ( ref($was_spspec) ne 'HASH' )
  {
    system("echo","\nSORRY: This flash-card isn't yet configured with a voice:\n");
    return;
  }
  
  if ( $was_spspec->{'typ'} eq 'synth' )
  {
    $lc_cm = 'languamunity';
    &wraprg::lst($lc_cm, ('say--' . $was_spspec->{'lng'}));
    &wraprg::lst($lc_cm, $was_spspec->{'gnd'}, $was_string);
    
    system($lc_cm);
  }
}

sub sayit {
  my $lc_cont;
  my $lc_mdv;
  my $lc_cm;
  my $lc_ok;
  my $lc_bg;
  
  $was_string = $_[0];
  $was_spspec = $_[1];
  $was_params = $_[2];
  
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




sub apro_say_q {
  my $lc_cm;
  if ( ref($qas_spspec) ne 'HASH' )
  {
    system("echo","\nSORRY: This flash-card isn't yet configured with a voice:\n");
    return;
  }
  
  if ( $qas_spspec->{'typ'} eq 'synth' )
  {
    $lc_cm = 'languamunity';
    &wraprg::lst($lc_cm, ('say--' . $qas_spspec->{'lng'}));
    &wraprg::lst($lc_cm, $qas_spspec->{'gnd'}, $qas_string);
    
    system($lc_cm);
  }
}

sub say_q {
  my $lc_cont;
  my $lc_mdv;
  my $lc_cm;
  my $lc_ok;
  my $lc_bg;
  
  $qas_string = $_[0];
  $qas_spspec = $_[1];
  $qas_params = $_[2];
  
  if ( !(defined($arcosa->{'stng'}->{'voca'})) ) { return; }
  $lc_ok = 0;
  $lc_bg = 0;
  if ( $arcosa->{'stng'}->{'voca'} eq 'q-on' ) { $lc_ok = 10; $lc_bg = 10; }
  if ( $arcosa->{'stng'}->{'voca'} eq 'q-fg' ) { $lc_ok = 10; }
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
