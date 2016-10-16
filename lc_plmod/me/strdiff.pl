#! /usr/bin/perl
use strict;

my $vika;
my $vikb;

($vika,$vikb) = @ARGV;

{
  my $lc_prefix;
  $lc_prefix = &string_differ($vika,$vikb);
  system("echo",ref($lc_prefix));
  system("echo",": " . $lc_prefix->[0] . " : " . $lc_prefix->[1] . " : " . $lc_prefix->[2] . " : " . $lc_prefix->[3] . " :");
}

sub string_differ {
  # Return value is an array-ref:
  # rt->[0] - Rg0 - the unique part
  # rt->[1] - Rg1 - the unique part
  # rt->[2] - Shared prefix
  # rt->[3] - Shared suffix
  my $lc_part_one;
  my $lc_part_two;
  my $lc_flpa;
  my $lc_flpb;
  my $lc_suffix;
  my $lc_ret;
  
  # The easy part is stripping away the common prefix
  $lc_part_one = &strip_common_prefix($_[0],$_[1]);
  
  # The suffix, though, requires reversing and re-reversing
  $lc_flpa = scalar reverse ($lc_part_one->[0]);
  $lc_flpb = scalar reverse ($lc_part_one->[1]);
  $lc_part_two = &strip_common_prefix($lc_flpa,$lc_flpb);
  $lc_flpa = scalar reverse ($lc_part_two->[0]);
  $lc_flpb = scalar reverse ($lc_part_two->[1]);
  $lc_suffix = scalar reverse ($lc_part_two->[3]);
  
  # And when we are done, we pack it into an array-ref to return it
  $lc_ret = [$lc_flpa,$lc_flpb,($lc_part_one->[3]),$lc_suffix];
  return $lc_ret;
}

sub strip_common_prefix {
  # Return value is an array-ref:
  # rt->[0] - Rg0 - with shared prefix removed
  # rt->[1] - Rg1 - with shared prefix removed
  # rt->[2] - Number of characters in shared prefix
  # rt->[3] - The shared prefix itself
  my $lc_rga;
  my $lc_rgb;
  my $lc_quia;
  my $lc_quib;
  my $lc_match;
  my $lc_rsl;
  my $lc_sizo;
  my $lc_pfix;
  
  ($lc_rga,$lc_rgb) = @_;
  ($lc_quia,$lc_quib) = @_;
  $lc_match = ($lc_rga ^ $lc_rgb) =~ /^(\x00*)/;
  
  # Generate the new, shortened strings
  substr $lc_quia, 0, $+[1], '' if $lc_match;
  substr $lc_quib, 0, $+[1], '' if $lc_match;
  
  # Find the length of what was removed
  $lc_sizo = int((length($lc_rga) - length($lc_quia)) + 0.2);
  
  # Generate a string containing the prefix
  $lc_pfix = substr $lc_rga, 0, $lc_sizo;
  
  # Return it all in a single array-ref
  $lc_rsl = [$lc_quia,$lc_quib,$lc_sizo,$lc_pfix];
  return $lc_rsl;
}


