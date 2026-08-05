BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use lib 'tools';
use ObjModule;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
for my $version ( Obj::min_version .. Obj::max_version ) {
    my $v00 = sprintf( "%02d", $version );
    run_ok(
"perl tools/z80objcopy.pl -v $version $dir/input/$self.1.def $dir/input/$self.$v00.o"
    );
    capture_ok(
"build/Debug/z88dk-z80asm -v -run-test=test_obj_wb_show_obj_file $dir/input/$self.$v00.o",
        "$dir/expected/$self-$v00.txt"
    );
    unlink "$dir/input/$self.$v00.o";
}

unlink_testfiles;
done_testing;
