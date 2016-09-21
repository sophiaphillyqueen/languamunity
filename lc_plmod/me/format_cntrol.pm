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
}


1;
