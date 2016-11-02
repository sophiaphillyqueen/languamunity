package me::pref_central;
use strict;
use chobak_jsonf;
use me::format_central;


# Has this module been initialized yet?
my $beeninit = 0;


# The location of the central directory:
my $cntrdir;

# The location of the central file-referemce:
my $cntrfloc;

# Location of the main object module:
my $cntrobj;


sub getobj {
  &initthis();
  return $cntrobj;
}


sub initthis {
  my $lc_cntrpram;
  my $lc_data;
  
  # Let us not run this function twice:
  if ( $beeninit > 5 ) { $beeninit = 10; return(2>1); }
  # Yes - in the first draft of this module this was all
  # done in extrafunctional space --- but it was moved
  # into a function that only does anything the first
  # time it is invoked so that a failure would not
  # interfere with the compilation of the full PERL
  # program.
  
  # First - we identify where the central directory is
  $cntrdir = $ENV{'HOME'};
  if ( $cntrdir eq '' )
  {
    $cntrdir = `echo ~`; chomp($cntrdir);
  }
  $cntrdir .= '/.chobakwrap/languamunity';
  system("mkdir","-p",$cntrdir);
  
  # Then - we identify where the central file is
  $cntrfloc = $cntrdir . '/central-pref.ref';
  
  # Setting up the main pref file:
  $lc_cntrpram = {
    'rtyp' => 'h',
    'create' => 'yes',
  };
  if ( ! ( &chobak_jsonf::byref($cntrfloc,$cntrobj,$lc_cntrpram) ) )
  {
    die "\nFailed to open the central preference file\n\n";
  }
  
  $lc_data = $cntrobj->cont();
  &me::format_central::struct_the_ref($lc_data);
  
  $beeninit = 10; return(2>1);
}


1;
