BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.m4, pass m4 options";
path("$test.asm.m4")->spew("OP");

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -m4=-DOP=nop -m4=-DDUMMY=1 -dump-after-cmdline $test.asm.m4", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
