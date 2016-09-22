package me::navig_index;
use strict;


sub find_the_lesson {
  my $lc_allindex;
  my $lc_lcnlist;
  my $lc_item;
  
  $lc_allindex = $_[1];
  if ( ref($lc_allindex) ne 'HASH' ) { return(1>2); }
  $lc_lcnlist = $lc_allindex->{'lcnx'};
  if ( ref($lc_lcnlist) ne 'ARRAY' ) { return(1>2); }
  foreach $lc_item (@$lc_lcnlist)
  {
    if ( ref($lc_item) eq 'HASH' )
    {
      if ( $lc_item->{'id'} eq $_[2] )
      {
        $_[0] = $lc_item;
        return(2>1);
      }
    }
  }
  return(1>2);
}

sub lesson_allowed {
  my $this;
  my $lc_prereq;
  my $lc_ctrol;
  my $lc_belt;
  my $lc_each_pr;
  my $lc_ok;
  my $lc_done;
  $this = $_[0];
  
  $lc_prereq = $this->{'prereq'};
  if ( ref($lc_prereq) ne 'ARRAY' ) { return(2>1); }
  
  $lc_ctrol = $this->{'ctrol'};
  if ( ref($lc_ctrol) ne 'HASH' ) { return(1>2); }
  
  $lc_belt = $lc_ctrol->{'lcnon'};
  if ( ref($lc_belt) ne 'ARRAY' ) { return(1>2); }
  
  foreach $lc_each_pr (@$lc_prereq)
  {
    $lc_ok = 0;
    foreach $lc_done (@$lc_belt)
    {
      if ( $lc_done eq $lc_each_pr ) { $lc_ok = 10; }
    }
    if ( $lc_ok < 5 ) { return(1>2); }
  }
  
  return(2>1);
}


1;
