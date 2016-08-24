package me::otherans;
use strict;

my $var_is_set = 0;
my $var_content = '';


sub do_clear {
  $var_is_set = 0;
  $var_content = '';
}

sub is_go {
  return ( $var_is_set > 5 );
}

sub do_set {
  $var_is_set = 10;
  $var_content = $_[0];
}

sub do_out {
  return $var_content;
}



1;
