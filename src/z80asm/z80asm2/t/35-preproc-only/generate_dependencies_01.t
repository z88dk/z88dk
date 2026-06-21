BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -E -MD $dir/input/$self.asm",
    "$dir/expected/$self.txt" );

check_text_file( "$dir/input/$self.i", "$dir/expected/$self.i" );
check_text_file( "$dir/input/$self.d", "$dir/expected/$self.d" );

unlink("$dir/input/$self.i") if Test::More->builder->is_passing;
unlink("$dir/input/$self.d") if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
