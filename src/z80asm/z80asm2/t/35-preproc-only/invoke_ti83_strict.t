BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -mti83_strict -E $dir/input/$self.asm",
    "$dir/expected/$self.txt" );
check_text_file( "$dir/input/$self.i", "$dir/expected/$self.i" );
unlink("$dir/input/$self.i") if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
