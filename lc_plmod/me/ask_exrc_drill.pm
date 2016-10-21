package me::ask_exrc_drill;
# The original form of the 'exrc' flashcard had one card-record
# per-form per-tense. This turned out to be a bit boggling -
# thus impeding the learning process. Therefore, this new
# variant is being implemented that allows me to drill all
# forms within a tense in a single flash-card as list form
# so that the focus-on-one-form-of-the-tense type flashcards
# will instead get auto-generated whenever the user
# indicates the need to do repetition-drilling on a
# specific, problematic form.
#
#
# It should be noted that NOTHING in this file should EVER
# be accessed DIRECTLY from OUTSIDE the file - with the
# exception of the function 'prime'.
#
# This is because everything else is part of the internal
# mechanics of the module.
use chobak_json;

my $qst_text;

sub prime {
  my $lc_useit;
  
  &chobak_json::clone($_[0],$lc_useit);
  
  # The question text starts empty until stuff gets
  # added to it:
  $qst_text = '';
  
  return 10;
}


1;
