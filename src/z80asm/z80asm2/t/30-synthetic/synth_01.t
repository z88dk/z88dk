BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use lib 'tools';
use ObjModule;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

for my $cpu ( CPU::all_cpus() ) {
    next if $cpu =~ /strict/;
    capture_ok(
"build/Debug/z88dk-z80asm -v -m$cpu -dump-after-synth-expansion $dir/input/$self.asm",
        "$dir/expected/${self}_${cpu}.txt"
    );
}

unlink_testfiles;
done_testing;
