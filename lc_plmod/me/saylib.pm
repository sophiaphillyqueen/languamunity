package me::saylib;
use strict;

sub slashlist {
  my $lc_each;
  my @lc_ret;
  my @lc_back;
  
  @lc_ret = ();
  foreach $lc_each (@_)
  {
    @lc_back = &slashone($lc_each);
    @lc_ret = (@lc_ret,@lc_back);
  }
  return @lc_ret;
}

sub slashone {
  my $lc_pre;
  my $lc_afopen;
  my @lc_ret;
  my @lc_back;
  my @lc_items;
  my $lc_eachit;
  my $lc_insid;
  my $lc_afclose;
  
  ($lc_pre,$lc_afopen) = split(quotemeta('['),$_[0],2);
  if ( $lc_pre eq $_[0] )
  {
    @lc_ret = ($lc_pre);
    return @lc_ret;
  }
  
  ($lc_insid,$lc_afclose) = split(quotemeta(']'),$lc_afopen,2);
  @lc_ret = ();
  @lc_items = split(quotemeta('/'),$lc_insid);
  foreach $lc_eachit (@lc_items)
  {
    @lc_back = &slashone(($lc_pre . $lc_eachit . $lc_afclose));
    @lc_ret = (@lc_ret,@lc_back);
  }
  
  return @lc_ret;
}

1;
