package Time::Piece::Over24;

use strict;
use warnings;
use vars qw/$VERSION/;
use Time::Piece;

$VERSION = "0.005";
my $OVER24_OFFSET = '00:00:00';

sub import { shift; @_ = ( "Time::Piece", @_ ); goto &Time::Piece::import }

package Time::Piece;

sub over24 {
    my ( $self, $time ) = @_;
    return $self->from_over24($time) if ($time);
    return $self->over24_time;
}

sub over24_time {
    my ( $self, $time ) = @_;
    return $self->from_over24_time($time) if ($time);

    my $hour = $self->hour;
    if ( $self < $self->_over24_offset_object ) {
        $self -= 86400;
        $hour += 24;
    }
    $hour = sprintf( "%02d", $hour );
    return $self->strftime("%Y-%m-%d $hour:%M:%S");
}

sub over24_datetime {
    my ( $self, $datetime ) = @_;
    return $self->from_over24_time($datetime) if ($datetime);
}

sub from_over24 {
    my ( $self, $time ) = @_;
    if ( $time =~ /\d\d:\d\d:\d\d/ ) {
        return $self->from_over24_time($time);
    }
    else {
        return $self->from_over24_datetime($time);
    }
}

sub from_over24_time {
    my ( $self, $time ) = @_;
    my $datetime = $self->ymd . " $time";
    return $self->_from_over24($datetime);
}

sub from_over24_datetime {
    my ( $self, $datetime ) = @_;
    return $self->_from_over24($datetime);
}

sub over24_offset {
    my ( $self, $offset ) = @_;
    if ($offset) {

        #just time
        if ( $offset =~ /^\d\d?$/ ) {
            $offset = sprintf( "%02d:00:00", $offset );
        }
        elsif ( $offset =~ /^\d\d?:\d\d$/ ) {
            $offset .= ":00";
        }
        $OVER24_OFFSET = $offset;
    }
    return $OVER24_OFFSET;
}

sub _over24_offset_object {
    my ($self) = @_;
    return $self->strptime( $self->ymd . " " . $self->over24_offset,
        '%Y-%m-%d %H:%M:%S' );
}

sub _over24 {
    my ( $self, $datetime ) = @_;

}

sub _from_over24 {
    my ( $self, $datetime ) = @_;
    my @hms = split /[\s:]/, $datetime;
    my $data = shift @hms;

    my $add_day = 0;
    if ( $hms[0] >= 24 ) {
        $add_day = int( $hms[0] / 24 );
        $hms[0] = sprintf( "%02d", $hms[0] - 24 * $add_day );
    }
    my $time = join ":", @hms;
    return $self->strptime( $data . " $time", "%Y-%m-%d %T" ) +
      $add_day * 86400;
}

1;
__END__

=head1 NAME

Time::Piece::Over24 - Adds over 24:00:00 methods to Time::Piece

=head1 SYNOPSIS

  use Time::Piece::Over24;

  my $t = localtime;

  #e.g. 2011-01-02 04:00:00 now
  #note 2011-01-"02", no 2011-01-"01"
  $t->over24_offset("05:00:00");
  print $t->over24_time;
  >2011-01-01 28:00:00

  #e.g. today is 2011-01-01
  #retun Time::Piece object
  my $over_time = $t->from_over24_time("26:00:00");
  my $over_datetime = $t->from_over24_datetime("2011-01-01 26:00:00");

  print $over_time->datetime;
  print $over_datetime->datetime;
  >2011-01-02 02:00:00
  
  #over24 is alias over24_time and from_over24_time and from_over24_datetime
  $t->over24(); #call over24_time;
  $t->over24("26:00:00"); #call from_over24_time
  $t->over24("2011-01-01 26:00:00"); #call from_over24_datetime

=head1 METHODS

=over 4

=item over24_offset

start hour a day.

default "00:00:00".

value is undef, return offset time.

print localtime->over24_offset();
>00:00:00

not undef is set offset time.

value format is "5" or "05" or "05:00" or "05:00:00", every format is ok.

but set value range is [00:00:00 - 23:59:59]

e.g. over24_offset("05:00:00"); #hour range is [05:00:00 - 28:59:59]

e.g. over24_offset("11:00:00"); #hour range is [11:00:00 - 34:59:59]

=item over24_time

get datetime in offset time

=item from_over24_time, from_voer24_datetime

return a Time::Piece object. 

*not null over24_time e.g.over24_time("26:00:00") is alias, from_over24_time
*not null over24_datetime e.g.over24_datetime("26:00:00") is alias, from_over24_datetime

=back

=head1 SEE ALSO

L<Time::Piece>, L<Time::Piece::MySQL>

=cut
