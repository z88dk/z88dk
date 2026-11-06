#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/999
# z80asm: unable to build consolidated object file from c source

spew( "${test}a.c", <<'END' );
unsigned char fa(void)
{
	return 100;
}
END

spew( "${test}b.c", <<'END' );
unsigned char fb(void)
{
	return 200;
}
END

run_ok("zcc +zx -c -clib=new ${test}a.c ${test}b.c -o ${test}cons.o");

capture_ok( "z88dk-z80nm -a ${test}cons.o", <<'END' );
Object  file test_t_issue_0999_tcons.o at $0000: Z80RMF18
  Name: test_t_issue_0999_tcons
  CPU:  z80 
  Section "": 0 bytes
  Section code_compiler: 8 bytes
    C $0000: 21 64 00 C9 21 C8 00 C9
  Section bss_compiler: 0 bytes
  Symbols:
    L C $0080: test_t_issue_0999_ta_c___fp_exponent_bias (section code_compiler) (file test_t_issue_0999_ta.c::fa::0::0:2)
    L C $0005: test_t_issue_0999_ta_c___fp_mantissa_size (section code_compiler) (file test_t_issue_0999_ta.c::fa::0::0:2)
    L C $0000: test_t_issue_0999_ta_c___fp_mode (section code_compiler) (file test_t_issue_0999_ta.c::fa::0::0:2)
    L C $0080: test_t_issue_0999_tb_c___fp_exponent_bias (section code_compiler) (file test_t_issue_0999_tb.c::fb::0::0:2)
    L C $0005: test_t_issue_0999_tb_c___fp_mantissa_size (section code_compiler) (file test_t_issue_0999_tb.c::fb::0::0:2)
    L C $0000: test_t_issue_0999_tb_c___fp_mode (section code_compiler) (file test_t_issue_0999_tb.c::fb::0::0:2)
    G A $0000: _fa (section code_compiler) (file test_t_issue_0999_ta.c::fa::0::0:2)
    G A $0004: _fb (section code_compiler) (file test_t_issue_0999_tb.c::fb::0::0:2)
  Strings:
    S   1 = "code_compiler"
    S   2 = "test_t_issue_0999_ta_c___fp_exponent_bias"
    S   3 = "test_t_issue_0999_ta.c::fa::0::0"
    S   4 = "test_t_issue_0999_ta_c___fp_mantissa_size"
    S   5 = "test_t_issue_0999_ta_c___fp_mode"
    S   6 = "test_t_issue_0999_tb_c___fp_exponent_bias"
    S   7 = "test_t_issue_0999_tb.c::fb::0::0"
    S   8 = "test_t_issue_0999_tb_c___fp_mantissa_size"
    S   9 = "test_t_issue_0999_tb_c___fp_mode"
    S  10 = "_fa"
    S  11 = "_fb"
    S  12 = "test_t_issue_0999_tcons"
    S  13 = "bss_compiler"
END

unlink_testfiles;
done_testing;
