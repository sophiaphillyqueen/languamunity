package me::houses;
use strict;
use chobak_jsonf;
use chobak_cstruc;

my $hme;

$hme = $ENV{'HOME'};
$languamdir = $hme . '/.chobakwrap/languamunity';
$housefile = $languamdir . '/housefile.ref';

system("mkdir","-p",$languamdir);

sub raise_houses_file {
  # Rg1 - If successful - this is the DESTINATION of the control
  #       object of LanguaMunitie's primary interlecional data:
  # RET - 'true' upon success - 'false' upon failure
  my $lc_obj;
  my $lc_dat;
  
  if ( !(&chobak_jsonf::byref($housefile,$lc_obj,{})) ) { return (1>2); }
  $lc_dat = $lc_obj->cont();
  
  &chobak_cstruc::force_hash_has_hash($lc_dat,'courses');
  
  $_[0] = $lc_obj;
  return (2>1);
}


sub char_alphanumeric {
  my $lc_val;
  $lc_val = ord($_[0]);
  if ( ( $lc_val >= ord('a') ) && ( $lc_val <= ord('z') ) ) { return(2>1); }
  if ( ( $lc_val >= ord('A') ) && ( $lc_val <= ord('Z') ) ) { return(2>1); }
  if ( ( $lc_val >= ord('0') ) && ( $lc_val <= ord('9') ) ) { return(2>1); }
  
  return(1>2);
}

sub string_ok {
  my $lc_cp;
  my $lc_chr;
  
  $lc_cp = $_[0];
  if ( $lc_cp eq '' ) { return(1>2); }
  while ( $lc_cp ne '' )
  {
    $lc_chr = chop($lc_cp);
    if ( !(&char_alphanumeric($lc_chr)) ) { return(1>2); }
  }
  return(2>1);
}








1;
