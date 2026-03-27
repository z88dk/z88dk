BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $self = path($0)->basename(".t");
my @expr = (
	'((((((5))))))',
	'((((1+2)*3)-4)/5)',
	'1+2+3+4+5+6+7+8+9+10',
	'1*2*3*4*5*6',
	'((((2**3)**2)**2)**2)',
	'--5',
	'-+5',
	'~-1',
	'!-1',
	'!-!0',
);

my $expr_cmd = "";
for my $i (0 .. $#expr) {
	$expr_cmd .= "'-D".sprintf("E%02d", $i)."=".$expr[$i]."' ";
}

capture_ok(
    "z88dk-z80asm $expr_cmd -dump-after-cmdline t/05-expr/input/empty.asm",
    "t/05-expr/expected/$self.txt"
);

unlink_testfiles;
done_testing;
