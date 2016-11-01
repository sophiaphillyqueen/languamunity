package me::chores_on_ctrl;
use me::format_cntrol;
use me::content_update;


sub pending {
  my $this;
  my $lc_cont;
  $this = $_[0];
  
  $lc_cont = $this->cont();
  
  # And just to make sure it is all properly formatted:
  &me::format_cntrol::struct_the_ref($lc_cont);
  
  # Do we do an update to everything?
  if ( $lc_cont->{'llstng'}->{'on-content-update'} > 5 )
  {
    if ( &me::content_update::prima($this) )
    {
      $lc_cont = $this->cont();
      $lc_cont->{'llstng'}->{'on-content-update'} = 0;
      $this->save();
    }
  }
  
  
  # And when we are all done, we return to the calling program.
  $lc_cont = $this->cont();
  return $lc_cont;
}



1;
