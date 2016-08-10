package me::extrac;
use strict;
use chobak_json;
use wraprg;

sub hashfrom {
  my $lc_ref;
  my @lc_ret;
  my $lc_each;
  
  $lc_ref = $_[0];
  @lc_ret = ();
  
  if ( ref($lc_ref) ne 'ARRAY' )  { return @lc_ret; }
  if ( $lc_ref->[0] eq 'cm' ) { return @lc_ret; }
  
  foreach $lc_each (@$lc_ref)
  {
    if ( ref($lc_each) eq 'HASH' ) { @lc_ret = (@lc_ret,$lc_each); }
    if ( ref($lc_each) eq 'ARRAY' ) { @lc_ret = (@lc_ret,&hashfrom($lc_each)); }
  }
  
  return @lc_ret;
}

sub mul_file_hash {
  my $lc_list;
  my $lc_each;
  my @lc_ret;
  
  @lc_ret = ();
  $lc_list = $_[0];
  foreach $lc_each (@$lc_list)
  {
    @lc_ret = (@lc_ret,&one_file_hash($lc_each,$_[1]));
  }
  
  return @lc_ret;
}

sub one_file_hash {
  my $lc_prm;
  my $lc_fnc;
  my @lc_ret;
  
  @lc_ret = ();
  
  $lc_prm = $_[1];
  if ( ref($lc_prm) ne 'HASH' ) { $lc_prm = {}; }
  
  if ( !( -f $_[0] ) )
  {
    $lc_fnc = $lc_prm->{'file-not-found'};
    if ( ref($lc_fnc) eq 'CODE' )
    {
      &$lc_fnc($_[0],$lc_prm);
    }
    return @lc_ret;
  }
  
  return(&hashfrom(&chobak_json::readf($_[0])));
}

1;
