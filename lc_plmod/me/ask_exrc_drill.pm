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
use chobak_json;


sub prime {
  my $lc_useit;
  
  &chobak_json::clone($_[0],$lc_useit);
}


1;
