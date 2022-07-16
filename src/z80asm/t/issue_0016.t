#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# cannot specify name of generated object file
spew("$test.asm", <<END);
		public test_function
test_function:  ret
local_function: ret
END

# assemble
unlink "$test.o";
run_ok("z88dk-z80asm $test.asm");
ok -f "$test.o", "$test.o exists";

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: $test
  Section "": 2 bytes
    C \$0000: C9 C9
  Symbols:
    L A \$0001 local_function (section "") (file $test.asm:3)
    G A \$0000 test_function (section "") (file $test.asm:2)
END

# assemble to a new object file in a different directory
unlink "$test.o";
path("$test.dir")->mkpath;
run_ok("z88dk-z80asm -O$test.dir -ozcc0000.o $test.asm");
ok ! -f "$test.o", "no $test.o";
ok -f "$test.dir/zcc0000.o", "$test.dir/zcc0000.o exists";

capture_ok("z88dk-z80nm -a $test.dir/zcc0000.o", <<END);
Object  file $test.dir/zcc0000.o at \$0000: Z80RMF16
  Name: zcc0000
  Section "": 2 bytes
    C \$0000: C9 C9
  Symbols:
    L A \$0001 test_t_issue_0016_local_function (section "") (file $test.asm:3)
    G A \$0000 test_function (section "") (file $test.asm:2)
END

path("$test.dir")->remove_tree;

unlink_testfiles;
done_testing;
