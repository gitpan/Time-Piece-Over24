package Time::Piece::Over24;

use strict;
use warnings;
use vars qw/$VERSION/;
use Time::Piece;

$VERSION = "0.001";

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

=pod

parase ovaer 24:00:00 and create new Time::Piece object

#Time::Piece 
my $t = locatime;

#ex today is 2011-01-01

#over24_time
my $over_time = $t->over24_time("26:00:00");
#over24_datetime
my $over_datetime = $t->over24_datetime("2011-01-01 26:00:00");

$over_time->datetime;
$over_datetime->datetime;

>2011-01-02 02:00:00


=cut


1;
