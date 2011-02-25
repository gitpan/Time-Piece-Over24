use Test::More tests=>2;

use Time::Piece::Over24;

my $t = localtime;
my $over = $t->over24_time("26:00:00");
is $over->hms,"02:00:00";

$over = $t->over24_datetime("2011-08-06 26:00:00");
is $over->datetime,"2011-08-07T02:00:00";

1;
