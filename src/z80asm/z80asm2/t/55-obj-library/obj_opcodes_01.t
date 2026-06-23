BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -dump-after-assembly $dir/input/$self.asm",
    "$dir/expected/$self.txt" );
capture_ok( "z88dk-z80nm -a $dir/input/$self.o", "$dir/expected/$self.dump" );

unlink_testfiles;
done_testing;
