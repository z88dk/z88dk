BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

note "preprocess .asm.pl";
path("$test.asm.pl")->spew("print 'nop';");

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -dump-after-cmdline $test.asm.pl", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
