#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2308
# z80asm: Header guards not working as expected

for my $define ("#define MEMMAPPER_DEFS_H_", 
				"define MEMMAPPER_DEFS_H_",
				"MEMMAPPER_DEFS_H_ equ 1",
				"defc MEMMAPPER_DEFS_H_ = 1",
				"macro MEMMAPPER_DEFS_H_ \n endm") {
	ok $define, $define;
	
	z80asm_ok("", "", "", <<END, bytes(1));
#ifndef MEMMAPPER_DEFS_H_
$define
	defb 1
#endif

#ifndef MEMMAPPER_DEFS_H_
$define
	defb 1
#endif
END
	die $define unless Test::More->builder->is_passing;

	z80asm_ok("", "", "", <<END, bytes(1));
#ifdef XXX
	defb 0
#elifndef MEMMAPPER_DEFS_H_
$define
	defb 1
#endif

#ifdef XXX
	defb 0
#elifndef MEMMAPPER_DEFS_H_
$define
	defb 1
#endif
END
	die $define unless Test::More->builder->is_passing;
}

unlink_testfiles;
done_testing;
