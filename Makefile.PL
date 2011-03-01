use inc::Module::Install;

name 'Time-Piece-Over24';
all_from 'lib/Time/Piece/Over24.pm';

build_requires 'Test::More';
requires 'Time::Piece';
license 'perl';

WriteAll;
