#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test -debug info in map file

# only ASM code
spew("${test}1.asm", <<END);
	public func

	c_line 1, "${test}1.c"
func:
	ld a, 1
	ld b, 3
	
	c_line 2
	add a, b
	ret
END

spew("${test}.asm", <<END);
	extern func

main:
	call func
	ret
END

run_ok("z88dk-z80asm -b -m ${test}.asm ${test}1.asm");

check_text_file("${test}.map", <<'END');
__head                          = $0000 ; const, public, def, , ,
__size                          = $000A ; const, public, def, , ,
__tail                          = $000A ; const, public, def, , ,
func                            = $0004 ; addr, public, , test_t_option_debug1, , test_t_option_debug1.c:1
main                            = $0000 ; addr, local, , test_t_option_debug, , test_t_option_debug.asm:3
END

run_ok("z88dk-z80asm -b -debug ${test}.asm ${test}1.asm");

check_text_file("${test}.map", <<'END');
__ASM_LINE_3_test_5ft_5foption_5fdebug_2easm = $0000 ; addr, local, , test_t_option_debug, , test_t_option_debug.asm:3
__C_LINE_1_test_5ft_5foption_5fdebug1_2ec = $0004 ; addr, local, , test_t_option_debug1, , test_t_option_debug1.c:1
__C_LINE_2_test_5ft_5foption_5fdebug1_2ec = $0008 ; addr, local, , test_t_option_debug1, , test_t_option_debug1.c:2
__head                          = $0000 ; const, public, def, , ,
__size                          = $000A ; const, public, def, , ,
__tail                          = $000A ; const, public, def, , ,
func                            = $0004 ; addr, public, , test_t_option_debug1, , test_t_option_debug1.c:1
main                            = $0000 ; addr, local, , test_t_option_debug, , test_t_option_debug.asm:3
END


# ASM and C code
SKIP: {
	skip "fails in SNAPcraft" if $ENV{SNAP};

unlink_testfiles();
spew("${test}1.asm", <<END);
	public _one
_one:
	ld hl, 1
	ret
END

spew("${test}.h", <<END);
// some
// random
extern int one();
// lines
END

spew("${test}.c", <<END);
#include "${test}.h"
int main() {
	return one()+one();
}
END

run_ok("zcc +zx -m -debug ${test}.c ${test}1.asm -o ${test}.bin");

(my $test_expanded = $test) =~ s/([^a-z0-9])/ sprintf("_%02x", ord($1)) /ige;
my @map = grep {!/zcc|crt0/ && /$test_expanded|_main|_one/} path("${test}.map")->lines;
spew("${test}1.map", @map);

check_text_file("${test}1.map", <<'END');
__ASM_LINE_2_test_5ft_5foption_5fdebug1_2easm = $80D0 ; addr, local, , test_t_option_debug1_asm, , test_t_option_debug1.asm:2
__C_LINE_0_test_5ft_5foption_5fdebug_2ec = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.c:0
__C_LINE_0_test_5ft_5foption_5fdebug_2eh = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.h:0
__C_LINE_1_test_5ft_5foption_5fdebug_2ec = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.c:1
__C_LINE_2_test_5ft_5foption_5fdebug_2ec = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.c:2
__C_LINE_2_test_5ft_5foption_5fdebug_2ec_3a_3amain_3a_3a0_3a_3a1 = $829F ; addr, local, , test_t_option_debug_c, code_compiler, test_t_option_debug.c::main::0::1:2
__C_LINE_3_test_5ft_5foption_5fdebug_2ec_3a_3amain_3a_3a1_3a_3a2 = $82A2 ; addr, local, , test_t_option_debug_c, code_compiler, test_t_option_debug.c::main::1::2:3
__C_LINE_3_test_5ft_5foption_5fdebug_2eh = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.h:3
__C_LINE_6_test_5ft_5foption_5fdebug_2eh = $80D0 ; addr, local, , test_t_option_debug_c, , test_t_option_debug.h:6
_main                           = $829F ; addr, public, , test_t_option_debug_c, code_compiler, test_t_option_debug.c::main::0::1:2
_one                            = $80D0 ; addr, public, , test_t_option_debug1_asm, , test_t_option_debug1.asm:2
END

}

unlink_testfiles;
done_testing;
