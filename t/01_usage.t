use Test::More tests=>8;

use Time::Piece::Over24;

my $t = localtime;
my $over = $t->from_over24_time("26:00:00");
is $over->hms,"02:00:00";

$over = $t->from_over24_datetime("2011-08-06 26:00:00");
is $over->datetime,"2011-08-07T02:00:00";

my $offset_test = $t->strptime("2011-01-02 02:00:00" , "%Y-%m-%d %H:%M:%S");

my $offset = $offset_test->over24_offset;
is $offset,"00:00:00";

my $datetime = $offset_test->over24_hour;
is $datetime,"2";

$datetime = $offset_test->over24_time;
is $datetime,"2011-01-02 02:00:00";

$offset = $offset_test->over24_offset("03:00:00");
is $offset,"03:00:00";

$datetime = $offset_test->over24_hour;
is $datetime,"26";

$datetime = $offset_test->over24_time();
is $datetime,"2011-01-01 26:00:00";


1;
