package me::extrac;
use strict;
use chobak_json;
use wraprg;
use Scalar::Util qw(looks_like_number);

sub hashfrom {
  my $lc_ref;
  my @lc_ret;
  my $lc_each;
  my $lc_reps;
  
  $lc_ref = $_[0];
  @lc_ret = ();
  
  if ( ref($lc_ref) ne 'ARRAY' )  { return @lc_ret; }
  if ( $lc_ref->[0] eq 'cm' ) { return @lc_ret; }
  $lc_reps = 1;
  if ( $lc_ref->[0] eq 'rep' )
  {
    if ( looks_like_number($lc_ref->[1]) )
    {
      if ( ($lc_ref->[1]) > 1 )
      {
        $lc_reps = $lc_ref->[1];
      }
    }
  }
  
  foreach $lc_each (@$lc_ref)
  {
    if ( ref($lc_each) eq 'HASH' )
    {
      my $lc3_a;
      my $lc3_b;
      my $lc3_c;
      
      $lc3_a = 0;
      if ( !(defined($_[1]->{'typ'})) ) { $lc3_a = 10; }
      
      if ( $lc3_a < 5 )
      {
        $lc3_b = $_[1]->{'typ'};
        if ( ref($lc3_b) eq 'ARRAY' )
        {
          foreach $lc3_c (@$lc3_b)
          {
            if ( $lc3_c eq $lc_each->{'typ'} ) { $lc3_a = 10; }
          }
        }
      }
      
      if ( $lc3_a > 5 ) { @lc_ret = (@lc_ret,$lc_each); }
    }
    if ( ref($lc_each) eq 'ARRAY' ) { @lc_ret = (@lc_ret,&hashfrom($lc_each,$_[1])); }
  }
  
  # Here we use the $lc_reps part:
  {
    my @lc2_a;
    my $lc2_b;
    @lc2_a = @lc_ret;
    $lc2_b = $lc_reps;
    while ( $lc2_b > 1.5 ) # Goes down to 1 instead of 0 - because one copy already is in there
    {
      @lc_ret = (@lc_ret,@lc2_a);
      $lc2_b = int($lc2_b - 0.8);
    }
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
  
  return(&hashfrom(&chobak_json::readf($_[0]),{}));
}

1;
