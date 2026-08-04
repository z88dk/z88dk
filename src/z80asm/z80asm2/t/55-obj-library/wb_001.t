BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test 001 - Minimal Object

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
run_ok("$^X tools/z80objcopy.pl $dir/input/$self.1.def $dir/input/$self.1.o");
capture_ok(
"build/Debug/z88dk-z80asm -v -run-test=test_obj_wb_001 $dir/input/$self.1.o",
    "$dir/expected/$self.txt"
);
unlink "$dir/input/$self.1.o";

unlink_testfiles;
done_testing;
