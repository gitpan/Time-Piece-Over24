package Time::Piece::Over24;

use strict;
use warnings;
use vars qw/$VERSION/;
use Time::Piece;

$VERSION = "0.002";

sub import { shift; @_ = ("Time::Piece",@_); goto &Time::Piece::import }

package Time::Piece;

sub over24_datetime {
  my ($self, $datetime) = @_;
  return $self->_over24($datetime);
};

sub over24_time {
  my ($self, $time) = @_;
  my $datetime =  $self->ymd." $time";
  return $self->_over24($datetime);
};

sub _over24 {
  my ($self,$datetime) = @_;
  my @hms = split /[\s:]/ ,$datetime;
  my $data = shift @hms;

  my $add_day = 0;
  if ($hms[0] >= 24) {
    $add_day = int($hms[0]/24);
    $hms[0] = sprintf("%02d",$hms[0]-24*$add_day);
  }
  my $time = join ":",@hms;
  return $self->strptime($data." $time","%Y-%m-%d %T") + $add_day*86400;
}

1;
__END__

=head1 NAME

Time::Piece::Over24 - Adds over 24:00:00 methods to Time::Piece

=head1 SYNOPSIS

use Time::Piece::Over24;

my $t = localtime;

#ex today is 2011-01-01
#over24_time
my $over_time = $t->over24_time("26:00:00");
#over24_datetime
my $over_datetime = $t->over24_datetime("2011-01-01 26:00:00");

print $over_time->datetime;
print $over_datetime->datetime;

>2011-01-02 02:00:00

=head1 SEE ALSO

L<Time::Piece>, L<Time::Piece::MySQL>

=cut
