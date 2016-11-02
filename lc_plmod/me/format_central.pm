package me::format_central;
use strict;
use chobak_cstruc;
use chobak_errutil;

sub struct_the_ref {
  my $lc_vl;
  $lc_vl = $_[0];
  if ( ref($lc_vl) ne 'HASH' ) { return; }
  
  # The 'houses' hash contains the information of
  # all the by-command-downloaded copies of courses
  # and the users's progress on them, etcetera.
  &chobak_cstruc::force_hash_has_hash($lc_vl,'houses');
}



1;
