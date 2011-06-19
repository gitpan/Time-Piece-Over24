use Test::More tests=>26;

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

$datetime = $offset_test->over24_hour;
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

#is_during test
my $flg = $t->is_during("10:00","11:00","10:30");
is $flg,1;

$flg = $t->is_during("10:00","11:00","11:30");
is $flg,undef;

$flg = $t->is_during("23:00","25:00","24:30");
is $flg,1;

$flg = $t->is_during("23:00","25:00","25:30");
is $flg,undef;

$flg = $t->is_during("2011-06-19 10:00:00","2011-06-19 11:00:00","2011-06-19 10:30:00");
is $flg,1;

$flg = $t->is_during("2011-06-19 10:00:00","2011-06-19 11:00:00","2011-06-19 11:30:00");
is $flg,undef;

my $t2 = $t->strptime("2011-06-19 10:00:00","%Y-%m-%d %T");
my $t3 = $t->strptime("2011-06-20 10:00:00","%Y-%m-%d %T");

$flg = $t->is_during($t2,$t3,"2011-06-19 10:30:00");
is $flg,1;

$flg = $t->is_during($t2,$t3,"2011-06-20 11:30:00");
is $flg,undef;


1;
