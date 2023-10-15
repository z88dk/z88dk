#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test error
z80asm_nok("", "", "label", <<END);
test_t_LABEL.asm:1: error: syntax error
  ^---- label
END

# test ok
z80asm_ok("", "", "", <<END, bytes(0..5));
		label1:	defb label1
		.label2	defb label2
		label3:	
				defb label3
		.label4	
				defb label4
		label5: defb label5 : label6: defb label6
END

unlink_testfiles;
done_testing;
