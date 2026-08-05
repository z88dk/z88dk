BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
run_ok("perl tools/z80objcopy.pl $dir/input/$self.1.def $dir/input/$self.1.o");
capture_ok(
"build/Debug/z88dk-z80asm -v -run-test=test_obj_wb_show_obj_file $dir/input/$self.1.o",
    "$dir/expected/$self.txt"
);
unlink "$dir/input/$self.1.o";

unlink_testfiles;
done_testing;
