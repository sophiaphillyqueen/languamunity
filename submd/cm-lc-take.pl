use strict;
use me::longterm;
use argola;
use chobak_json;

my $arcosa;
my $deckref;
my $eachfile;
my $eachfcon;


$arcosa = &me::longterm::load();

$deckref = $arcosa->{'deck'};
while ( &argola::yet() )
{
  $eachfile = &argola::getrg();
  $eachfcon = &chobak_json::readf($eachfile);
  if ( ref($eachfcon) eq 'ARRAY' )
  {
    @$deckref = (@$deckref,&hashfrom($eachfcon));
  }
}

sub hashfrom {
  my $lc_ref;
  my @lc_ret;
  my $lc_each;
  
  $lc_ref = $_[0];
  @lc_ret = ();
  
  if ( ref($lc_ref) ne 'ARRAY' )  { return @lc_ret; }
  if ( $lc_ref->[0] eq 'cm' ) { return @lc_ret; }
  
  foreach $lc_each (@$lc_ref)
  {
    if ( ref($lc_each) eq 'HASH' ) { @lc_ret = (@lc_ret,$lc_each); }
    if ( ref($lc_each) eq 'ARRAY' ) { @lc_ret = (@lc_ret,&hashfrom($lc_each)); }
  }
  
  return @lc_ret;
}


&me::longterm::save($arcosa);





