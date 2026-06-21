BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
for my $cpu ( 'z80', 'gbz80', 'r4k' ) {
    capture_nok(
        "z88dk-z80asm -v -m$cpu -dump-after-layout $dir/input/$self.asm",
        "$dir/expected/${self}_${cpu}.txt" );
}
unlink_testfiles;
done_testing;
