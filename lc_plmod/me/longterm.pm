package me::longterm;
# This package implements the long-term memory of the command.
use strict;
use chobak_json;
use chobak_cstruc;

my $memdir;

$memdir = $ENV{"HOME"} . "/.chobakwrap/languamunity";
system("mkdir","-p",$memdir);
system("rm","-rf",&fjsnm('fail'));


sub get_crit_d {
  return $memdir;
}


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
  return &load_quiz_file($memdir . '/main-file.json');
}

sub load_quiz_file {
  my $lc_vl;
  
  # First we load what is previously in the file - and assure that
  # it is a hash:
  $lc_vl = &chobak_json::readf($_[0]);
  
  &formatref($lc_vl);
  $lc_vl->{'filename'} = $_[0];
  
  return $lc_vl;
}

sub save {
  my $lc_vl;
  $lc_vl = $_[0];
  &formatref($lc_vl);
  &chobak_json::savef($lc_vl,$lc_vl->{'filename'});
}

sub load_core {
  my $lc_corefile;
  my $lc_vl;
  
  $lc_corefile = $memdir . '/core-file.json';
  $lc_vl = &chobak_json::readf($lc_corefile);
  
  # We must force the root element of the file to be a HASH
  if ( ref($lc_vl) ne 'HASH' ) { $lc_vl = {}; }
  
  $lc_vl->{'filename'} = $lc_corefile;
  
  &chobak_cstruc::force_hash_has_hash($lc_vl,'units');
  
  return $lc_vl;
}

sub load_hash {
  my $lc_vl;
  
  $lc_vl = &chobak_json::readf($_[0]);
  
  # We must force the root element of the file to be a HASH
  if ( ref($lc_vl) ne 'HASH' ) { $lc_vl = {}; }
  
  $lc_vl->{'filename'} = $_[0];
  
  return $lc_vl;
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
  
  # Now we make sure we have the out-corner piles as the
  # destinations for questions to which you got the
  # wrong answer.
  &chobak_cstruc::force_hash_has_array($lc_vl,'redeck');
  &chobak_cstruc::force_hash_has_array($lc_vl,'rehand');
  
  # Now make sure that the structure has a hand:
  &chobak_cstruc::force_hash_has_array($lc_vl,'hand');
  
  # Now the intermediate waiting-slots between:
  &chobak_cstruc::force_hash_has_array($lc_vl,'hnd01');
  &chobak_cstruc::force_hash_has_array($lc_vl,'hnd02');
  &chobak_cstruc::force_hash_has_array($lc_vl,'hnd03');
  # And the one that is NOT slated for deprecation
  &chobak_cstruc::force_hash_has_array($lc_vl,'mtdeck');
  
  # Now a space is needed for the name categories
  &chobak_cstruc::force_hash_has_hash($lc_vl,'names');
  
  # And other input-related records (such as ID-number of latest name)
  &chobak_cstruc::force_hash_has_hash($lc_vl,'inrc');
  
  # And, of course, we need some place to store the settings:
  &chobak_cstruc::force_hash_has_hash($lc_vl,'stng');
  
  # A place to store information on when a a new New Questions
  # deck is opened. This information can be useful in determining
  # when it is time to add a new lesson.
  &chobak_cstruc::force_hash_has_array($lc_vl,'gradrec');
  
  # I think that, from now on, the presence of vocalization
  # should be the default.
  &chobak_cstruc::force_hash_has_it($lc_vl->{'stng'},'voca','on');
}



1;
