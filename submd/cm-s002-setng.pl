use strict;
use argola;
use chobak_jsonf;
use me::format_cntrol;
use Cwd qw(realpath);
use File::Basename;

my $stnobj;
my $stnpref;
my $stndat;

$stnpref = {
  'rtyp' => 'h',
};

if ( !(&chobak_jsonf::byref(&argola::getrg(),$stnobj,$stnpref)) )
{
  die("\nFatal Error -\nAttempt to open control file yielded error " .
    $stnpref->{'errorinfo'}->{'errid'} .
  ":\n\n");
}

$stndat = $stnobj->cont();
&me::format_cntrol::struct_the_ref($stndat);

sub opto__indexfile_do {
  my $lc_a;
  my $lc_b;
  $lc_a = &argola::getrg();
  if ( ! ( -f $lc_a ) )
  {
    die("\nFATAL ERROR: No such file: " . $lc_a . ":\n\n");
  }
  $lc_b = realpath($lc_a);
  if ( ! ( -f $lc_b ) )
  {
    die("\nFATAL ERROR: Pointless alias: " . $lc_a . ":\n\n");
  }
  $stndat->{'indexfile'} = $lc_b;
}; &argola::setopt('-indexfile',\&opto__indexfile_do);

sub opto__quizfile_do {
  my $lc_quizfile_raw;
  my $lc_quiz_dir_raw;
  my $lc_quiz_basename;
  my $lc_quiz_dir_real;
  my $lc_final_quiz_name;
  my $lc_xa;
  
  $lc_quizfile_raw = &argola::getrg();
  ($lc_quiz_basename,$lc_quiz_dir_raw,$lc_xa) = fileparse($lc_quizfile_raw);
  chop($lc_quiz_dir_raw);
  
  if ( ! ( ( -d $lc_quiz_dir_raw ) || ( -f $lc_quiz_dir_raw ) ) )
  {
    die("\nFATAL ERROR: Fictional Directory:\n  ",$lc_quiz_dir_raw,":\n\n");
  }
  $lc_quiz_dir_real = realpath($lc_quiz_dir_raw);
  if ( ! ( -d $lc_quiz_dir_real ) )
  {
    die("\nFATAL ERROR: Non-Directory:\n  ",$lc_quiz_dir_raw,":\n\n");
  }
  $lc_final_quiz_name = ( $lc_quiz_dir_real . '/' . $lc_quiz_basename );
  $stndat->{'quizfile'} = $lc_final_quiz_name;
  
} &argola::setopt('-quizfile',\&opto__quizfile_do);

&argola::runopts();

$stnobj->save();



