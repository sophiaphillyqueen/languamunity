use strict;
use argola;
use chobak_json;
use chobak_jsonf;
use me::format_cntrol;
use chobak_flf;
use chobinfodig;

my $cntrpram;
my $arg_is_01;
my $cntrobj;
my $cntrd;
my $index;

$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};

$arg_is_01 = &argola::getrg();
if ( ! ( &chobak_jsonf::byref($arg_is_01,$cntrobj,$cntrpram) ) )
{
  die("\nFailed to open the file: " . $arg_is_01 . ":\n\n");
}
$cntrd = $cntrobj->cont();
&me::format_cntrol::struct_the_ref($cntrd);
$index = &chobak_json::readf($cntrd->{'indexfile'});

sub opto__idcd_do {
  my $lc_a;
  $lc_a = &argola::getrg();
  &show_lesson_for_lit($lc_a);
} &argola::setopt('-idcd',\&opto__idcd_do);

argola::runopts();


sub show_lesson_for_lit {
  my $lc_lcnlist;
  my $lc_eachlcn;
  
  if ( ref($index) ne 'HASH' ) { return(1>2); }
  $lc_lcnlist = $index->{'lcnx'};
  if ( ref($lc_lcnlist) ne 'ARRAY' ) { return(1>2); }
  foreach $lc_eachlcn (@$lc_lcnlist)
  {
    if ( &show_lesson_if_match_id($lc_eachlcn,$_[0]) ) { return(2>1); }
  }
  return(1>2);
}

sub show_lesson_if_match_id {
  my $lc_thisid;
  
  if ( ref($_[0]) ne 'HASH' ) { return(1>2); }
  $lc_thisid = $_[0]->{'id'};
  if ( $lc_thisid ne $_[1] ) { return(1>2); }
  
  &show_lect_of_lcn($_[0]);
  
  return(2>1);
}

sub show_lect_of_lcn {
  my $lc_lctlist;
  my $lc_each;
  
  if ( ref($_[0]) ne 'HASH' ) { return(1>2); }
  $lc_lctlist = $_[0]->{'lect'};
  if ( ref($lc_lctlist) ne 'ARRAY' ) { return(1>2); }
  foreach $lc_each (@$lc_lctlist)
  {
    &show_lect_item($lc_each);
  }
  return(2>1);
}

sub show_lect_item {
  my $lc_typ;
  
  if ( ref($_[0]) ne 'HASH' ) { return(1>2); }
  if ( !(defined($_[0]->{'typ'})) )
  {
    die "\nFATAL ERROR: Lect item with undefined type:\n\n";
  }
  $lc_typ = $_[0]->{'typ'};
  
  if ( $lc_typ eq 'relhtm' )
  {
    my $lc2_a;
    my $lc2_b;
    
    $lc2_a = &chobak_flf::realpath(&chobak_flf::k_gdr($cntrd->{'indexfile'}));
    $lc2_b = $lc2_a . '/' . $_[0]->{'loc'};
    system("chobakwrap",'-sub','browseropen',$lc2_b);
    
    return(2>1);
  }
  
  die("\nFATAL ERROR: Unknown lecture-item type: " . $lc_typ . ":\n\n");
}






