BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

# module with incompatible swap_ixiy

my @temp;
my @input;
for my $def (<$dir/input/$self.o.*.def>) {
    my $o = $def =~ s/\.def$/.o/r;
    push @input, $o;
    push @temp,  $o;
    run_ok("perl tools/z80objcopy.pl $def $o");
}

my @libs;
for my $def (<$dir/input/$self.lib.*.def>) {
    my $lib = $def =~ s/\.def$/.lib/r;
    push @libs, "-l$lib";
    push @temp, $lib;
    run_ok("perl tools/z80objcopy.pl $def $lib");
}

capture_nok(
    "build/Debug/z88dk-z80asm -v -b -dump-after-module-resolver @libs @input",
    "$dir/expected/$self.txt" );

unlink @temp if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
