use strict;
use argola;
use wraprg;
use plelorec;

my $comname;
$comname = &argola::getrg();

sub try_in_our_subdir {
  my $lc_cmfl;
  my @lc_cmln;
  
  $lc_cmfl = &argola::srcd() . "/submd/cm-" . $comname . ".pl";
  if ( -f $lc_cmfl )
  {
    @lc_cmln = ($lc_cmfl);
    while ( &argola::yet() )
    {
      @lc_cmln = (@lc_cmln,&argola::getrg());
    }
    plelorec::flplex(@lc_cmln);
    exit(0);
  }
}

sub try_in_command_path {
  my $lc_scm;
  my $lc_loc;
  my @lc_cmln;
  
  $lc_scm = 'which ' . &wraprg::bsc('languamunity-cm-' . $comname);
  $lc_loc = `$lc_scm`; chomp($lc_loc);
  if ( $lc_loc eq '' ) { return; }
  @lc_cmln = ($lc_loc);
  while ( &argola::yet() )
  {
    @lc_cmln = (@lc_cmln,&argola::getrg());
  }
  exec(@lc_cmln);
  exit(0);
}


# First we try to find it in our subdirectory:
&try_in_our_subdir();
# Then we try to search the command path:
&try_in_command_path();



die "\nNo such 'languamunity' command as: '" . $comname . "':\n\n";



