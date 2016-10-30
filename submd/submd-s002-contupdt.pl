use strict;
use argola;
use chobak_jsonf;
use chobak_json;


# First the litany that loads the Control File and the Index
# File - as well as identifies the locations of both those plus
# the Quizfile
$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};
if ( ! ( &chobak_jsonf::byref(&argola::getrg(),$cntrobj,$cntrpram) ) )
{
  die "\nFailed to open the file\n\n";
}
$cntrd = $cntrobj->cont();
$index = &chobak_json::readf($cntrd->{'indexfile'});
$quizfile = $cntrd->{'quizfile'};
if ( $quizfile eq '' ) { die "\nNo quiz-file specified:\n\n"; }


