use Test::More tests=>18;

use Time::Piece::Over24;

my $t = localtime;
my $over = $t->from_over24_time("26:00:00");
is $over->hms,"02:00:00";

$over = $t->from_over24_datetime("2011-09-15 26:00:00");
is $over->datetime,"2011-09-16T02:00:00";

my $offset_test = $t->strptime("2011-01-01 02:00:00" , "%Y-%m-%d %H:%M:%S");

my $offset = $offset_test->over24_offset;
is $offset,"00:00:00";

my $datetime = $offset_test->over24;
is $datetime,"2011-01-01 02:00:00";

$datetime = $offset_test->over24_year;
is $datetime,"2011";

$datetime = $offset_test->over24_mon;
is $datetime,"1";

$datetime = $offset_test->over24_mday;
is $datetime,"1";

my $datetime = $offset_test->over24_hour;
is $datetime,"2";

$datetime = $offset_test->over24_time;
is $datetime,"02:00:00";

$datetime = $offset_test->over24_datetime;
is $datetime,"2011-01-01 02:00:00";

$offset = $offset_test->over24_offset("03:00:00");
is $offset,"03:00:00";

$datetime = $offset_test->over24;
is $datetime,"2010-12-31 26:00:00";

$datetime = $offset_test->over24_year;
is $datetime,"2010";

$datetime = $offset_test->over24_mon;
is $datetime,"12";

$datetime = $offset_test->over24_mday;
is $datetime,"31";

$datetime = $offset_test->over24_hour;
is $datetime,"26";

$datetime = $offset_test->over24_time;
is $datetime,"26:00:00";

$datetime = $offset_test->over24_datetime;
is $datetime,"2010-12-31 26:00:00";

1;
