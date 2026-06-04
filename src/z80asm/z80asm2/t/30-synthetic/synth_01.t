BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

for my $cpu (
    '8080',      '8085', 'ez80', 'ez80_z80', 'gbz80', 'kc160',
    'kc160_z80', 'r2ka', 'r3k',  'r4k',      'r5k',   'r6k',
    'r800',      'z80',  'z80n', 'z180'
    )
{
    my $dir  = path($0)->dirname;
    my $self = path($0)->basename(".t");
    capture_ok(
"z88dk-z80asm -v -m$cpu -dump-after-synth-expansion $dir/input/$self.asm",
        "$dir/expected/${self}_${cpu}.txt"
    );
}

unlink_testfiles;
done_testing;
