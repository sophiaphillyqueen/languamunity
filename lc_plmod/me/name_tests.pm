package me::name_tests;
use strict;
use chobak_cstruc;




sub get_namevars {
  my $lc_namevar;
  my $lc_all_reqs;
  my $lc_each_req;
  
  $lc_all_reqs = $_[1];
  $lc_namevar = {};
  
  foreach $lc_each_req (@$lc_all_reqs)
  {
    # If we fail to resolve any one of the prescribed name variables,
    # then this function will fail and the question will be dropped.
    # To prevent this, the preparer of the course must assure
    # a sufficient number of names in each category.
    if ( &get_a_namevar($lc_namevar,[
      $lc_each_req->[0],
      $_[2],
      $lc_each_req->[1],
    ],$_[3],$_[4]) < 5 ) { return 0; }
  }
  
  $_[0] = $lc_namevar;
  return 10;
}

sub get_a_namevar {
  # 0 -- Name variables
  # 1 -- Name-resource requirement (with language-spec added)
  # 2 -- Clone of namesource
  # 3 -- Names accepted so far
  my $lc_require;
  my $lc_acpsofar;
  my $lc_namespace;
  my $lc_trial;
  my $lc_ok;
  
  $lc_require = $_[1]->[0];
  $lc_acpsofar = $_[3];
  $lc_namespace = $_[2]->{$lc_require};
  while ( &chobak_cstruc::counto($lc_namespace) > 0.5 )
  {
    $lc_ok = 10;
    $lc_trial = &chobak_cstruc::ry_hat($lc_namespace);
    if ( &chobak_cstruc::within($lc_trial->{'id'},$lc_acpsofar) ) { $lc_ok = 0; }
    if ( $lc_ok > 5 )
    {
      if ( !(&fits_req($lc_trial,$_[1]->[1],$_[1]->[2])) ) { $lc_ok = 0; } 
    }
    
    if ( $lc_ok > 5 )
    {
      @$lc_acpsofar = (@$lc_acpsofar,$lc_trial->{'id'});
      &add_the_namevar($lc_trial,$_[1]->[1],$_[1]->[2],$_[0]);
      return 10;
    }
  }
  
  return 0;
}



sub fits_req {
  # This function identifies returns a decabool indicating whether
  # or not a name resource being put on trial meets the requirements
  # set forth by the question.
  # Rg0 -- Name-resource on trial
  # Rg1 -- Array of languages that must be supported
  # Rg2 -- Array of modes that must be supported
  # RET -- Does this name-resource meet the requirements?
  my $lc_all_langs;
  my $lc_each_lang;
  my $lc_lang_res;
  my $lc_scenario;
  my $lc_ok;
  
  $lc_all_langs = $_[1];
  
  
  if ( ref($_[0]) ne 'HASH' ) { return ( 0 > 5 ); }
  if ( ref($_[0]->{'val'}) ne 'HASH' ) { return ( 0 > 5 ); }
  
  foreach $lc_each_lang (@$lc_all_langs)
  {
    $lc_lang_res = $_[0]->{'val'}->{$lc_each_lang};
    if ( ref($lc_lang_res) ne 'ARRAY' ) { return ( 0 > 5 ); }
    $lc_ok = 0;
    foreach $lc_scenario (@$lc_lang_res)
    {
      if ( &good_scenario($lc_scenario,$_[2]) > 5 ) { $lc_ok = 10; }
    }
    if ( $lc_ok < 5 ) { return ( 0 > 5 ); }
  }
  return ( 10 > 5 );
}

sub good_scenario {
  # Rg0 - Scenario Being tested
  # Rg1 - List of modes that must be supported
  # RET - 10 if the scenario passes the test - 0 otherwise
  my $lc_list;
  my $lc_each;
  
  if ( ref($_[0]) ne 'HASH' ) { return 0; }
  $lc_list = $_[1];
  if ( ref($lc_list) ne 'ARRAY' ) { return 0; }
  foreach $lc_each (@$lc_list)
  {
    my $lc2_x;
    
    if ( &chobak_cstruc::counto($lc_each) < 1.5 ) { return 0; }
    
    $lc2_x = $lc_each->[0];
    if ( !defined($_[0]->{$lc2_x}) ) { return 0; }
  }
  return 10;
}


sub add_the_namevar {
  # Rg0 - The name-resource to add
  # Rg1 - Array of languages to add
  # Rg2 - Array of mode-variable combos to add
  # Rg3 - Namevar data-structure to add it to
  my $lc_lang_list;
  my $lc_each_lang;
  
  $lc_lang_list = $_[1];
  foreach $lc_each_lang (@$lc_lang_list)
  {
    &chobak_cstruc::force_hash_has_array($_[3],$lc_each_lang);
    if ( &chobak_cstruc::counto($_[3]->{$lc_each_lang}) < 0.5 )
    {
      $_[3]->{$lc_each_lang} = [{}];
      &add_the_lang_namevar(
        $_[0]->{'val'}->{$lc_each_lang},
        $_[2],
        $_[3]->{$lc_each_lang}
      )
    }
  }
}

sub add_the_lang_namevar {
  # 0 - The list of scenarios with modes of this language of the name-resource
  # 1 - A list of modes to source - and the variable to save them to
  # 2 - The lang-specific namespace to add it to:
  my $lc_all_scenarios_src;
  my $lc_each_scenario_src;
  my $lc_all_scenarios_dst_ref; # The old list previously assembled
  my @lc_all_scenarios_dst_ray; # The new list being assembled
  my $lc_each_scenario_dst_old; # Original from the Old List
  my $lc_each_scenario_dst_new; # Clone for the New List
  my $lc_all_modes;
  my $lc_each_mode;
  my $lc_mode_name;
  my $lc_var_name;
  
  $lc_all_scenarios_src = $_[0];
  $lc_all_scenarios_dst_ref = $_[2];
  @lc_all_scenarios_dst_ray = ();
  foreach $lc_each_scenario_src (@$lc_all_scenarios_src)
  {
  
    if ( &good_scenario($lc_each_scenario_src,$_[1]) > 5 )
    {
      foreach $lc_each_scenario_dst_old (@$lc_all_scenarios_dst_ref)
      {
        &chobak_json::clone($lc_each_scenario_dst_old,$lc_each_scenario_dst_new);
        
        $lc_all_modes = $_[1];
        foreach $lc_each_mode (@$lc_all_modes)
        {
          $lc_mode_name = $lc_each_mode->[0];
          $lc_var_name = $lc_each_mode->[1];
          $lc_each_scenario_dst_new->{$lc_var_name} = $lc_each_scenario_src->{$lc_mode_name};
        }
        
        @lc_all_scenarios_dst_ray = (@lc_all_scenarios_dst_ray,$lc_each_scenario_dst_new);
      }
    }
  }
  @$lc_all_scenarios_dst_ref = (@lc_all_scenarios_dst_ray);
}





1;
