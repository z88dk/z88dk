#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/2422
# z80asm: Parallel build issues

# only one object file
path("$test.dir")->remove_tree;
unlink_testfiles;

mkdir "$test.dir";
spew("$test.asm", "public aa \n aa: nop");

capture_ok("z88dk-z80asm -v -o=$test.dir/$test.o $test.asm", <<'END');
% z88dk-z80asm -v -o=test_t_issue_2422.dir/test_t_issue_2422.o test_t_issue_2422.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2422.asm'
Writing object file 'test_t_issue_2422.dir/test_t_issue_2422.o'

END

ok !-f "$test.o", "no object file in asm directory";
ok -f "$test.dir/$test.o", "object file in target directory";

capture_ok("z88dk-z80nm -a $test.dir/$test.o", <<'END');
Object  file test_t_issue_2422.dir/test_t_issue_2422.o at $0000: Z80RMF18
  Name: test_t_issue_2422
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00
  Symbols:
    G A $0000: aa (section "") (file test_t_issue_2422.asm:2)
END


# two object files
path("$test.dir")->remove_tree;
unlink_testfiles;

mkdir "$test.dir";
spew("$test.1.asm", "public aa \n aa: nop");
spew("$test.2.asm", "public bb \n bb: nop");

capture_ok("z88dk-z80asm -v -o=$test.dir/$test.o $test.1.asm $test.2.asm", <<'END');
% z88dk-z80asm -v -o=test_t_issue_2422.dir/test_t_issue_2422.o test_t_issue_2422.1.asm test_t_issue_2422.2.asm
Predefined constant: __CPU_Z80__ = 1
Predefined constant: __CPU_ZILOG__ = 1
Predefined constant: __FLOAT_GENMATH__ = 1
Reading library 'z88dk-z80asm.lib'
Assembling 'test_t_issue_2422.1.asm'
Writing object file 'test_t_issue_2422.1.o'

Assembling 'test_t_issue_2422.2.asm'
Writing object file 'test_t_issue_2422.2.o'

Writing object file 'test_t_issue_2422.dir/test_t_issue_2422.o'
END

ok -f "$test.1.o", "object file in asm directory";
ok -f "$test.2.o", "object file in asm directory";
ok -f "$test.dir/$test.o", "object file in target directory";

capture_ok("z88dk-z80nm -a $test.dir/$test.o $test.1.o $test.2.o", <<'END');
Object  file test_t_issue_2422.dir/test_t_issue_2422.o at $0000: Z80RMF18
  Name: test_t_issue_2422
  CPU:  z80 
  Section "": 2 bytes
    C $0000: 00 00
  Symbols:
    G A $0000: aa (section "") (file test_t_issue_2422.1.asm:2)
    G A $0001: bb (section "") (file test_t_issue_2422.2.asm:2)
Object  file test_t_issue_2422.1.o at $0000: Z80RMF18
  Name: test_t_issue_2422.1
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00
  Symbols:
    G A $0000: aa (section "") (file test_t_issue_2422.1.asm:2)
Object  file test_t_issue_2422.2.o at $0000: Z80RMF18
  Name: test_t_issue_2422.2
  CPU:  z80 
  Section "": 1 bytes
    C $0000: 00
  Symbols:
    G A $0000: bb (section "") (file test_t_issue_2422.2.asm:2)
END

path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;

