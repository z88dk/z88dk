#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test LINE and C_LINE

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

z80asm(<<'END', "", 1, "", <<'END');
	line 10
	ld
END
Error at file 'test.asm' line 10: syntax error
1 errors occurred during assembly
END

z80asm(<<'END', "", 1, "", <<'END');
	line 10
	nop
	ld
END
Error at file 'test.asm' line 11: syntax error
1 errors occurred during assembly
END

z80asm(<<'END', "", 1, "", <<'END');
	line 10, "hello.asm"
	nop
	ld
END
Error at file 'hello.asm' line 11: syntax error
1 errors occurred during assembly
END

z80asm(<<'END', "", 1, "", <<'END');
	c_line 10


	ld
END
Error at file 'test.asm' line 10: syntax error
1 errors occurred during assembly
END

z80asm(<<'END', "", 1, "", <<'END');
	c_line 10, "test.c"


	ld
END
Error at file 'test.c' line 10: syntax error
1 errors occurred during assembly
END

unlink_testfiles();
done_testing();
