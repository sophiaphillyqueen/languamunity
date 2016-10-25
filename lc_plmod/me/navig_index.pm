package me::navig_index;
use strict;

my $index;

sub mem_index {
  $index = $_[0];
}


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

sub substi_alias {
  my $lc_src;
  my $lc_dst;
  my $lc_each;
  ($lc_src,$lc_dst) = @_;
  
  if ( ref($lc_src) ne 'ARRAY' ) { return; }
  if ( ref($lc_dst) ne 'ARRAY' )
  {
    $lc_dst = [];
    $_[1] = $lc_dst;
  }
  
  @$lc_dst = ();
  if ( !(defined($index->{'alias'})) ) { @$lc_dst = @$lc_src; return; }
  
  foreach $lc_each (@$lc_src)
  {
    if ( defined($index->{'alias'}->{$lc_each}) )
    {
      my $lc3_a;
      $lc3_a = $index->{'alias'}->{$lc_each};
      @$lc_dst = (@$lc_dst,@$lc3_a);
    } else {
      @$lc_dst = (@$lc_dst,$lc_each);
    }
  }
}

sub lesson_allowed {
  my $this;
  my $lc_prereq;
  my $lc_exprereq;
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
  
  &substi_alias($lc_prereq,$lc_exprereq);
  foreach $lc_each_pr (@$lc_exprereq)
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
