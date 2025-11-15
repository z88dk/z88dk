#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $test_dir = "$test.dir";
path("$test_dir/include")->mkpath;

# include files with the same name in different directories
spew("$test.inc", "file 1\n");
spew("$test_dir/$test.inc", "file 2\n");
spew("$test_dir/include/$test.inc", "file 3\n");

# asm in top directory
spew("$test.asm", <<END);
    INCLUDE "$test.inc"
    INCLUDE <$test.inc>
    INCLUDE  $test.inc
END

capture_ok("z88dk-z80asm -v -E -I$test_dir/include $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.inc"
file 1
#line 1, "$test_dir/include/$test.inc"
file 3
#line 1, "$test.inc"
file 1
END

# asm in subdirectory
spew("$test_dir/$test.asm", <<END);
    INCLUDE "$test.inc"
    INCLUDE <$test.inc>
    INCLUDE  $test.inc
END

capture_ok("z88dk-z80asm -v -E -I$test_dir/include $test_dir/$test.asm", <<END);
Preprocessing file: $test_dir/$test.asm -> $test_dir/$test.i
END

check_text_file("$test_dir/$test.i", <<END);
#line 1, "$test_dir/$test.inc"
file 2
#line 1, "$test_dir/include/$test.inc"
file 3
#line 1, "$test_dir/$test.inc"
file 2
END

path($test_dir)->remove_tree if Test::More->builder->is_passing;
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
