BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir  = path($0)->dirname;
my $self = path($0)->basename(".t");
capture_ok( "z88dk-z80asm -v -E $dir/input/$self.1.asm $dir/input/$self.2.asm",
    "$dir/expected/$self.txt" );
check_text_file( "$dir/input/$self.1.i", "$dir/expected/$self.1.i" );
check_text_file( "$dir/input/$self.2.i", "$dir/expected/$self.2.i" );
unlink("$dir/input/$self.1.i") if Test::More->builder->is_passing;
unlink("$dir/input/$self.2.i") if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
