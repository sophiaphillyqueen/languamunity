use strict;
use argola;
use chobak_hook02;
use chobak_json;
use chobak_cstruc;
use me::extrac;

my $phase_in = [];
my $phase_save = [];

my $itemas = [];



sub func__to__on {
  my $lc_rg;
  
  $lc_rg = &argola::getrg();
  
  &chobak_hook02::onto($phase_save,\&content_save,$lc_rg);
} &argola::setopt('-to',\&func__to__on);


sub func__ft__on {
  my $lc_rg;
  
  $lc_rg = &argola::getrg();
  
  &chobak_hook02::onto($phase_in,\&content_in,$lc_rg);
  &chobak_hook02::onto($phase_save,\&content_save,$lc_rg);
} &argola::setopt('-ft',\&func__ft__on);


sub funct__lm__on {
  my $lc_rg;
  
  $lc_rg = &argola::getrg();
  
  &chobak_hook02::onto($phase_in,\&content_limit,$lc_rg);
} &argola::setopt('-lm',\&funct__lm__on);


sub funct__cnt__on {
  &chobak_hook02::onto($phase_in,\&content_count);
} &argola::setopt('-cnt',\&funct__cnt__on);



sub func__f__on {
  my $lc_rg;
  
  $lc_rg = &argola::getrg();
  
  &chobak_hook02::onto($phase_in,\&content_in,$lc_rg);
} &argola::setopt('-f',\&func__f__on);

&argola::runopts();

&chobak_hook02::asany($phase_in);
&chobak_hook02::asany($phase_save);

sub content_in {
  my $lc_cont_a;
  my @lc_cont_b;
  
  $lc_cont_a = &chobak_json::readf($_[0]);
  @lc_cont_b = &me::extrac::hashfrom($lc_cont_a,
    {
      'typ' => ['smtx','subst','exrc'],
    }
  );
  @$itemas = (@$itemas,@lc_cont_b);
}

sub content_count {
  system("echo",&chobak_cstruc::counto($itemas));
}

sub content_limit {
  my @lc_srcray;
  my @lc_dstray;
  my $lc_lefto;
  my $lc_maxo;
  my $lc_item;
  
  &chobak_cstruc::shfl($itemas);
  @lc_srcray = @$itemas;
  @lc_dstray = ();
  $lc_maxo = @lc_srcray;
  if ( $lc_maxo > $_[0] ) { $lc_maxo = $_[0]; }
  $lc_lefto = $lc_maxo;
  while ( $lc_lefto > 0.5 )
  {
    $lc_item = shift(@lc_srcray);
    @lc_dstray = (@lc_dstray,$lc_item);
    $lc_lefto = int($lc_lefto - 0.8);
  }
  @$itemas = @lc_dstray;
}

sub content_save {
  &chobak_json::savef($itemas,$_[0]);
}




