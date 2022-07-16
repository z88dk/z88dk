#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# z80asm: C_LINE directive not supported with DEFVARS block
# https://github.com/z88dk/z88dk/issues/1852

z80asm_ok("", "", "", <<'END', bytes(0, 1));
		DEFVARS 0 {
		C_LINE  126,"stdio.h"
		C_LINE  126
			fp_desc         ds.w    1
		}
		
		DEFGROUP {
		C_LINE  126,"stdio.h"
		C_LINE  126
			f1 = 1
		}
		
		C_LINE  126,"stdio.h"
		C_LINE  126
		
		DEFB fp_desc, f1
END

unlink_testfiles;
done_testing;
