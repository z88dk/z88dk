BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

$ENV{Z80ASM} = "-DENV_DEFINED";

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -dump-after-cmdline $dir/input/empty.asm", "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
