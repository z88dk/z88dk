BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $self = path($0)->basename(".t");
my @expr = (
	'1/0',
	'5%+0',
	'A/(B-B)',
);

my $expr_cmd = "-DA=5 -DB=2 ";
for my $i (0 .. $#expr) {
	$expr_cmd .= "'-D".sprintf("E%02d", $i)."=".$expr[$i]."' ";
}

capture_ok(
    "z88dk-z80asm $expr_cmd -dump-after-cmdline t/05-expr/input/empty.asm",
    "t/05-expr/expected/$self.txt"
);

unlink_testfiles;
done_testing;
