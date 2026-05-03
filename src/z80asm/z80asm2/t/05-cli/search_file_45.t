BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "both exist, .asm is newer, option -d, give .o";

path("$test.o")->spew("");
sleep(1);
path("$test.asm")->spew("nop");

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -d -dump-after-cmdline $test.o", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
