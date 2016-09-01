package me::ask_subst;
use strict;
use chobak_json;
use me::name_tests;
use me::name_work;
use me::ask_smtx;
use chobinfodig;

sub prime {
  my $lc_clone;
  my $lc_idsofar;
  my $lc_namevar;
  my $lc_q_lang;
  my $lc_a_lang;
  my $lc_neoques; # The 'smtx' rendition of the question
  my $lc_cp_neoques; # Copy of the 'smtx' rendition of the question
  my $lc_all_can_be;
  my $lc_all_alterns;
  my $lc_each_altern;
  
  system("echo","\n");
  
  # First, we generate a clone of all the RELEVANT namespaces,
  # so that any changes made to the namespaces in the name
  # selection process don't alter the original data.
  $lc_clone = &clone_namespaces($_[0]->{'pre'},$_[1]->{'main'}->{'names'});
  
  # Now we get ready to keep track of what names we have so far selected.
  $lc_idsofar = [];
  
  if ( &me::name_tests::get_namevars($lc_namevar,$_[0]->{'pre'},$_[0]->{'lang'},$lc_clone,$lc_idsofar) < 5 )
  {
    system("echo","NAMESOURCE INSUFFICIENCY: Question Dropped:");
    return 10;
  }
  
  $lc_q_lang = $_[0]->{'lang'}->[0];
  $lc_a_lang = $_[0]->{'lang'}->[1];
  
  $lc_neoques = {
    'typ' => 'smtx',
    'lang' => $_[0]->{'lang'},
  };
  
  $lc_all_can_be = &me::name_work::resolve([$_[0]->{'q'}],$lc_namevar->{$lc_q_lang});
  $lc_neoques->{'q'} = &chobak_cstruc::ry_hat($lc_all_can_be);
  $lc_neoques->{'a'} = &me::name_work::resolve($_[0]->{'a'},$lc_namevar->{$lc_a_lang});
  
  if ( ref($_[0]->{'o'}) eq 'ARRAY' )
  {
    my $lc2_altern = [];
    $lc_all_alterns = $_[0]->{'o'};
    foreach $lc_each_altern (@$lc_all_alterns)
    {
      if ( &chobak_cstruc::counto($lc_each_altern) > 1.5 )
      {
        my @lc4_ry;
        my $lc4_exp;
        my $lc4_ret;
        @lc4_ry = @$lc_each_altern;
        $lc4_exp = shift(@lc4_ry);
        $lc4_ret = &me::name_work::resolve(\@lc4_ry,$lc_namevar->{$lc_a_lang});
        @$lc4_ret = ($lc4_exp,@$lc4_ret);
        @$lc2_altern= (@$lc2_altern,$lc4_ret);
      }
    }
    $lc_neoques->{'o'} = $lc2_altern;
  }
  
  #&chobinfodig::dumpy('BANDUK',$lc_neoques);
  $_[1]->{'pristine'} = $_[0];
  &chobak_json::clone($lc_neoques,$lc_cp_neoques);
  $_[1]->{'err_deck'} = [$_[0]];
  $_[1]->{'err_hand'} = [$lc_cp_neoques];
  return &me::ask_smtx::artifice($lc_neoques,$_[1]);
  
  #system("echo","HERE WILL EVENTUALLY GO A STRING-SUBSTITUTION QUESTION:");
  #return 10;
}

sub clone_namespaces {
  my $lc_cycula;
  my $lc_ret;
  my $lc_pret;
  my $lc_each;
  my $lc_nms;
  
  $lc_pret = {};
  $lc_ret = {};
  
  if ( ref($_[0]) ne 'ARRAY' ) { return $lc_ret; }
  $lc_cycula = $_[0];
  foreach $lc_each (@$lc_cycula)
  {
    my $lc2_a;
    $lc_nms = $lc_each->[0];
    $lc2_a = $_[1]->{$lc_nms};
    if ( defined($lc2_a) ) { $lc_pret->{$lc_nms} = $lc2_a; }
  }
  &chobak_json::clone($lc_pret,$lc_ret);
  
  return $lc_ret;
}


1;
