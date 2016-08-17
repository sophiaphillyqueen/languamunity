package me::longterm;
# This package implements the long-term memory of the command.
use strict;
use chobak_json;
use chobak_cstruc;

my $memdir;

$memdir = $ENV{"HOME"} . "/.chobakwrap/languamunity";
system("mkdir","-p",$memdir);
system("rm","-rf",&fjsnm('fail'));




sub savefail {
  my $lc_filn;
  my $lc_cont;
  
  $lc_filn = &fjsnm('fail');
  $lc_cont = &chobak_json::readf($lc_filn);
  @$lc_cont = (@$lc_cont,@_);
  &chobak_json::savef($lc_cont,$lc_filn);
}


sub fjsnm {
  return($memdir . '/' . $_[0] . '.json');
}

sub load {
  my $lc_vl;
  
  # First we load what is previously in the file - and assure that
  # it is a hash:
  $lc_vl = &chobak_json::readf($memdir . '/main-file.json');
  
  &formatref($lc_vl);
  
  return $lc_vl;
}

sub save {
  my $lc_vl;
  $lc_vl = $_[0];
  &formatref($lc_vl);
  &chobak_json::savef($lc_vl,$memdir . '/main-file.json');
}

sub formatref {
  my $lc_vl;
  $lc_vl = $_[0];
  
  if ( ref($lc_vl) ne 'HASH' )
  {
    $lc_vl = {};
    $_[0] = $lc_vl;
  }
  
  # Now we make sure that this structure has a queue:
  &chobak_cstruc::force_hash_has_array($lc_vl,'queue');
  
  # Now we make sure that this structure has the deck:
  &chobak_cstruc::force_hash_has_array($lc_vl,'deck');
  
  # Now make sure that the structure has a hand:
  &chobak_cstruc::force_hash_has_array($lc_vl,'hand');
  
  # Now a space is needed for the name categories
  &chobak_cstruc::force_hash_has_hash($lc_vl,'names');
  
  # And other input-related records (such as ID-number of latest name)
  &chobak_cstruc::force_hash_has_hash($lc_vl,'inrc');
  
  # And, of course, we need some place to store the settings:
  &chobak_cstruc::force_hash_has_hash($lc_vl,'stng');
}



1;
