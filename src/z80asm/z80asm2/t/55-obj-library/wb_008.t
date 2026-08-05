BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");

my $def = "; Stress test\n";
$def .= "begin library\n";
for my $m ( 0 .. 255 ) {
    $def .= "  begin module\n";
    $def .= "    name = module$m\n";
    $def .= "    begin symbols\n";
    for my $s ( 0 .. 255 ) {
        $def .= "      begin symbol\n";
        $def .= "        name = public${m}_${s}\n";
        $def .= "        scope = Public\n";
        $def .= "        type = Constant\n";
        $def .= "        value = " . ( ( $m << 8 ) | $s ) . "\n";
        $def .= "      end symbol\n";
    }
    $def .= "    end symbols\n";
    $def .= "  end module\n";
}
$def .= "end library\n";
path("$dir/input/$self.1.def")->spew_raw($def);

run_ok("perl tools/z80objcopy.pl $dir/input/$self.1.def $dir/input/$self.1.o");
capture_ok(
"build/Debug/z88dk-z80asm -v -run-test=test_obj_wb_lookup_symbols $dir/input/$self.1.o",
    "$dir/expected/$self.txt"
);
unlink "$dir/input/$self.1.o";

unlink_testfiles;
done_testing;
