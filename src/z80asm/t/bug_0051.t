#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0051: DEFC and DEFVARS constants do not appear in map file
z80asm_ok("-r4 -b -m -g -Dminus_d_var", "", "", <<END, 
			public minus_d_var, defc_var, defvars_var, public_label
			defc defc_var = 2
			defvars 3 { 
				defvars_var ds.b 1
			}
		public_label: 
			defb minus_d_var	;; 01
			defb defc_var		;; 02
			defb defvars_var	;; 03
			defb public_label	;; 04
			defb local_label 	;; 09
		local_label:
END
	bytes(1, 2, 3, 4, 9));

check_text_file("$test.def", <<END);
DEFC minus_d_var                     = \$0001
DEFC defc_var                        = \$0002
DEFC defvars_var                     = \$0003
DEFC public_label                    = \$0004
END

check_text_file("$test.map", <<END);
local_label                     = \$0009 ; addr, local, , $test, , $test.asm:12
minus_d_var                     = \$0001 ; const, public, , $test, , $test.o:0
defc_var                        = \$0002 ; const, public, , $test, , $test.asm:2
defvars_var                     = \$0003 ; const, public, , $test, , $test.asm:4
public_label                    = \$0004 ; addr, public, , $test, , $test.asm:6
__head                          = \$0004 ; const, public, def, , ,
__tail                          = \$0009 ; const, public, def, , ,
__size                          = \$0005 ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
