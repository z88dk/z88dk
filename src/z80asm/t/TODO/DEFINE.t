#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

z80asm_nok("", "", <<END, <<END);
		define
END
$test.asm:1: error: syntax error
  ^---- define
END

z80asm_nok("", "", <<END, <<END);
		define aa,
END
$test.asm:1: error: syntax error
  ^---- define aa,
END

z80asm_nok("", "", <<END, <<END);
		undefine
END
$test.asm:1: error: syntax error
  ^---- undefine
END

z80asm_nok("", "", <<END, <<END);
		undefine aa,
END
$test.asm:1: error: syntax error
  ^---- undefine aa,
END

z80asm_ok("", "", "", <<END, bytes(1));
		define aa
		defb aa
END

z80asm_ok("", "", "", <<END, bytes(1, 1));
		define aa, bb
		defb aa, bb
END

z80asm_ok("", "", "", <<END, bytes(1));
		define aa, bb
		undefine aa
		defb bb
END

z80asm_nok("", "", <<END, <<END);
		define aa, bb
		undefine aa
		defb aa
END
$test.asm:3: error: undefined symbol: aa
  ^---- aa
END

z80asm_nok("", "", <<END, <<END);
		define aa, bb
		undefine aa, bb
		defb aa
END
$test.asm:3: error: undefined symbol: aa
  ^---- aa
END

z80asm_nok("", "", <<END, <<END);
		define aa, bb
		undefine aa, bb
		defb bb
END
$test.asm:3: error: undefined symbol: bb
  ^---- bb
END

unlink_testfiles;
done_testing;
