#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/655
# z80asm: object file incorrect with correct lis input

spew("${test}.asm", <<'END');
	SECTION rodata_driver

	TESTING1:  	DEFB    $55

	DEFC    	ENTRY =	_cpm_bdos_head		; expression does not appear in nm!

	_rodata_cpm_ccp_head:

	PHASE   0xD800

	CBASE:    	JP    COMMAND
				JP    CLEARBUF

	TESTING2:  	DEFB    $AA

	CLEARBUF:	RET
	COMMAND:	RET

	ALIGN   0x100

	_cpm_bdos_head:

	DEPHASE

	SECTION bss_user
END

capture_ok("z88dk-z80asm -l ${test}.asm", "");

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 0 bytes
  Section rodata_driver: 257 bytes
    C \$0000: 55 C3 08 D8 C3 07 D8 AA C9 C9 00 00 00 00 00 00
    C \$0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00A0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00B0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00C0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00D0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00E0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$00F0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    C \$0100: 00
  Section bss_user: 0 bytes
  Symbols:
    L A \$0000: TESTING1 (section rodata_driver) (file ${test}.asm:3)
    L C \$D900: _cpm_bdos_head (section rodata_driver) (file ${test}.asm:21)
    L = \$0000: ENTRY (section rodata_driver) (file ${test}.asm:5)
    L A \$0001: _rodata_cpm_ccp_head (section rodata_driver) (file ${test}.asm:7)
    L C \$D808: COMMAND (section rodata_driver) (file ${test}.asm:17)
    L C \$D800: CBASE (section rodata_driver) (file ${test}.asm:11)
    L C \$D807: CLEARBUF (section rodata_driver) (file ${test}.asm:16)
    L C \$D806: TESTING2 (section rodata_driver) (file ${test}.asm:14)
  Expressions:
    E = \$0001 \$0001 0: ENTRY := _cpm_bdos_head (section rodata_driver) (file ${test}.asm:5)
END

unlink_testfiles;
done_testing;
