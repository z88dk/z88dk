BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -I$dir/input/library -dump-after-directives $dir/input/$self.asm",
    "$dir/expected/$self.txt" );

unlink_testfiles;
done_testing;
