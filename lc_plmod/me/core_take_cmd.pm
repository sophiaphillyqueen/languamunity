package me::core_take_cmd;
use strict;

my $arcosa;
my $deckref;

sub set_arcosa_var {
  $arcosa = $_[0];
  $deckref = $arcosa->{'deck'};
}




sub one_round {
  my $lc_eachfile;
  my $lc_eachfcon;
  
  $lc_eachfile = $_[0];
  $lc_eachfcon = &chobak_json::readf($lc_eachfile);
  if ( ref($lc_eachfcon) eq 'ARRAY' )
  {
    my @lc2_noma;
    my $lc2_name;
    @$deckref = (@$deckref,&me::extrac::hashfrom($lc_eachfcon,{
      'typ' => ['smtx','subst'],
    }));
    
    @lc2_noma = &me::extrac::hashfrom($lc_eachfcon,{
      'typ' => ['name'],
    });
    foreach $lc2_name (@lc2_noma)
    {
      &process_name($lc2_name);
    }
  }
}


sub process_name {
  my $lc_nm;
  my $lc_id;
  my $lc_nsets;
  my $lc_ctgls;
  my $lc_categ;
  
  if ( ref($_[0]) ne 'HASH' ) { return; }
  $lc_nm = $_[0];
  if ( ref($lc_nm->{'ctg'}) ne 'ARRAY' ) { return; }
  $lc_nsets = $arcosa->{'names'};
  $lc_ctgls = $lc_nm->{'ctg'};
  foreach $lc_categ (@$lc_ctgls)
  {
    my $lc2_nry;
    &chobak_cstruc::force_hash_has_array($lc_nsets,$lc_categ);
    $lc2_nry = $lc_nsets->{$lc_categ};
    @$lc2_nry = (@$lc2_nry,$_[0]);
  }
  
  $lc_id = int($arcosa->{'inrc'}->{'nameid'} + 1.2);
  $lc_nm->{'id'} = $lc_id;
  
  $arcosa->{'inrc'}->{'nameid'} = $lc_id;
}


1;
