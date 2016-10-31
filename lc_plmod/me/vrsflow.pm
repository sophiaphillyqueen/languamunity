package me::vrsflow;
use strict;

use chobinfodig;

sub do_replace {
  my $lc_dustyray;
  my $lc_eachone;
  my $lc_swapsrc;
  my @lc_neoray;
  
  # First we make sure that the source in the index
  # file is sound.
  if ( ref($_[0]) ne 'HASH' ) { return; }
  if ( !defined($_[0]->{'replace'}) ) { return; }
  if ( ref($_[0]->{'replace'}) ne 'HASH' ) { return; }
  
  # Then we do the same with the array that we will
  # have to manipulate in the control file.
  if ( ref($_[1]) ne 'HASH' ) { return; }
  if ( !defined($_[1]->{'lcnon'}) ) { return; }
  if ( ref($_[1]->{'lcnon'}) ne 'ARRAY' ) { return; }
  
  $lc_dustyray = $_[1]->{'lcnon'};
  $lc_swapsrc = $_[0]->{'replace'};
  @lc_neoray = ();
  foreach $lc_eachone (@$lc_dustyray)
  {
    my $lc2_ok;
    $lc2_ok = 10;
    
    # If a swapsrc was found, it becomes the
    # new and replaces the old.
    if ( defined($lc_swapsrc->{$lc_eachone}) )
    {
      my $lc3_neos;
      my $lc3_repla;
      my $lc3_alrt;
      $lc3_neos = $lc_swapsrc->{$lc_eachone};
      $lc3_alrt = "REPLACING:\n  " . $lc_eachone . ':';
      foreach $lc3_repla (@$lc3_neos)
      {
        @lc_neoray = (@lc_neoray,$lc3_repla);
        $lc3_alrt .= "\n      --> " . $lc3_repla . ' :';
      }
      
      system("echo",$lc3_alrt);
      $lc2_ok = 0;
    }
    
    
    # If no swapsrc was found, the old becomes
    # the new.
    if ( $lc2_ok > 5 )
    {
      @lc_neoray = (@lc_neoray,$lc_eachone);
    }
  }
  @$lc_dustyray = @lc_neoray;
  
  #&chobinfodig::refxx('KAUA',$_[0]->{'replace'});
  #&chobinfodig::refxx('ZIRO',$_[1]->{'lcnon'});
}



1;
