package me::format_cntrol;
use strict;
use chobak_cstruc;
use chobak_errutil;

sub struct_the_ref {
  my $lc_vl;
  $lc_vl = $_[0];
  if ( ref($lc_vl) ne 'HASH' ) { return; }
  
  
  # The list of lessons currently-and-previously the focus
  # of study
  &chobak_cstruc::force_hash_has_array($lc_vl,'lcnon');
  
  # THE CRUCIAL LOW-LEVEL SETTINGS VARIABLES
  #   Variables here do not reflect user-preferences, but
  #   rather, are settings that the software-package itself
  #   sets to keep track of it's place in various processes.
  
  # First, we set up the hash for all these variables.
  &chobak_cstruc::force_hash_has_hash($lc_vl,'llstng');
  
  # The update of content files is a multi-stage process
  # which if it is interrupted in the middle, it must
  # be automatically redone from scratch lest an
  # incomplete form of it corrupt everything.
  &frcdefine($lc_vl->{'llstng'},'on-content-update',0);
  
  # END OF LOW-LEVEL SETTINGS VARIABLES
}


sub frcdefine {
  if ( defined($_[0]->{$_[1]}) ) { return; }
  $_[0]->{$_[1]} = $_[2];
}


1;
