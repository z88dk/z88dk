#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# test continuation lines
z80asm_ok("-b -l", "$test.asm", "",
		  "ld a,\\", 	bytes(0x3e),
		  "1",			bytes(1));
check_txt_file("$test.lis", <<'END');
1     0000              ld a,\
2     0000  3E 01       1
3     0002              
END

# test split lines
z80asm_ok("-b -l", "$test.asm", "",
		  "ld a,1\\ret", 	bytes(0x3e, 1, 0xc9));
check_txt_file("$test.lis", <<'END');
1     0000  3E 01 C9    ld a,1\ret
2     0003              
END

unlink_testfiles;
done_testing;
