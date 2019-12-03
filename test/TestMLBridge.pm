use strict; use warnings;
package TestMLBridge;
use base 'TestML::Bridge';

use File::Temp qw/tempdir/;
use Capture::Tiny 'capture';

sub undent {
  my ($self, $text) = @_;
  $text =~ s/^    //mg;
  return $text;
}

sub compile {
  my ($self, $stp) = @_;

  my ($temp_dir) = tempdir or die;
  my $temp_file = "$temp_dir/test.stp";
  open my $temp_handle, '>', $temp_file
    or die "Can't open '$temp_file' for output: $!";
  print $temp_handle $stp;
  close $temp_handle;

  my ($stdout, $stderr, $rc) = capture {
    system("schematype-compiler $temp_file");
  };

  die "Error while testing schematype-compiler:\n$stderr"
    if $rc != 0;

  warn $stderr if $stderr;

  return $stdout;
}

1;
