#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test LINE and C_LINE

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

z80asm(<<'END', "", 1, "", <<'END');
	line 10
	ld
END
Error at file 'test.asm' line 10: syntax error
END

z80asm(<<'END', "", 1, "", <<'END');
	line 10
	nop
	ld
END
Error at file 'test.asm' line 11: syntax error
END

z80asm(<<'END', "", 1, "", <<'END');
	line 10, "hello.asm"
	nop
	ld
END
Error at file 'hello.asm' line 11: syntax error
END

z80asm(<<'END', "", 1, "", <<'END');
	c_line 10


	ld
END
Error at file 'test.asm' line 10: syntax error
END

z80asm(<<'END', "", 1, "", <<'END');
	c_line 10, "test.c"


	ld
END
Error at file 'test.c' line 10: syntax error
END

z80asm(<<'END', "", 1, "", <<'END');
	extern THE_LINE
	line THE_LINE
	line THE_LINE, "file1.asm"
END
Error at file 'test.asm' line 2: expected constant expression
Error at file 'test.asm' line 3: expected constant expression
END

z80asm(<<'END', "", 1, "", <<'END');
	extern THE_LINE
	c_line THE_LINE
	c_line THE_LINE, "file1.c"
END
Error at file 'test.asm' line 2: expected constant expression
Error at file 'test.asm' line 3: expected constant expression
END

unlink_testfiles();
done_testing();
