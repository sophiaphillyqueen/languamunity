package me::name_work;
use strict;

sub resolve {
  # Rg0 -- Array-ref of sources to resolve
  # Rg1 -- Language-specific namespace (an array-ref of scenarios)
  # RET >> Array-ref of possible resolutions
  my $lc_ret;
  my $lc_one_ans;
  my $lc_one_part;
  my $lc_type;
  my $lc_bthat;
  my $lc_all_sources;
  my $lc_each_source;
  my $lc_each_scenario;
  my $lc_all_scenarios;
  
  $lc_ret = [];
  $lc_all_sources = $_[0];
  $lc_all_scenarios = $_[1];
  foreach $lc_each_source (@$lc_all_sources)
  {
    foreach $lc_each_scenario (@$lc_all_scenarios)
    {
      $lc_one_ans = '';
      foreach $lc_one_part (@$lc_each_source)
      {
        $lc_type = substr($lc_one_part,0,1);
        $lc_bthat = substr($lc_one_part,1);
        if ( $lc_type eq '/' )
        {
          $lc_one_ans .= $lc_bthat;
        }
        if ( $lc_type eq '*' )
        {
          $lc_one_ans .= $lc_each_scenario->{$lc_bthat};
        }
      }
      @$lc_ret = (@$lc_ret,$lc_one_ans);
    }
  }
  
  return $lc_ret;
}



1;
