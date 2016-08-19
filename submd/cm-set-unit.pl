use strict;
# USAGE: languamunity set-unit [unitdir]
use me::longterm;
use File::Basename;
use Cwd 'realpath';
use argola;

my $thecore;
my $unitdir;
my $unitname;
my $unitcore;

$thecore = &me::longterm::load_core();


if ( !(&argola::yet()) )
{
  die("\n" .
    "FATAL ERROR:\n" .
    "  USAGE: languamunity set-unit [unitdir]\n" .
  "\n");
}
{
  my $lc_a;
  $lc_a = &argola::getrg();
  if ( !(-d $lc_a) )
  {
    die("\n" .
    "FATAL ERROR:\n" .
    "  languamunity set-unit: No such directory\n" .
    "  Provided dir-name: " . $lc_a . ":\n" .
  "\n");
  }
  $unitdir = realpath($lc_a);
}


$unitcore = &chobak_json::readf($unitdir . '/main.json');





