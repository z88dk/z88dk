#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;


z80asm_nok("", "", <<'END', <<'END');
@l1:            ; error, no parent label
END
test_t_local_labels_t.asm:1: error: local label without normal label before it: @l1
  ^---- @l1: ; error, no parent label
      ^---- @l1:
END


z80asm_nok("", "", <<'END', <<'END');
g2@l2:          ; error
END
test_t_local_labels_t.asm:1: error: local label with global prefix: g2@l2
  ^---- g2@l2: ; error
      ^---- g2@l2:
END


z80asm_nok("", "", <<'END', <<'END');
    jp @l2      ; error, undefined symbol
END
test_t_local_labels_t.asm:1: error: local label without normal label before it: @l2
  ^---- jp @l2 ; error, undefined symbol
      ^---- jp @l2
test_t_local_labels_t.asm:1: error: undefined symbol: @l2
  ^---- @l2
END


z80asm_nok("", "", <<'END', <<'END');
    section aa
g1:
    section bb
@l1:            ; error, no parent label
END
test_t_local_labels_t.asm:4: error: local label without normal label before it: @l1
  ^---- @l1: ; error, no parent label
      ^---- @l1:
END


z80asm_nok("", "", <<'END', <<'END');
g1:
	phase 0
@l1:            ; error, no parent label
END
test_t_local_labels_t.asm:3: error: local label without normal label before it: @l1
  ^---- @l1: ; error, no parent label
      ^---- @l1:
END


z80asm_nok("", "", <<'END', <<'END');
	phase 0
g1:
	dephase
@l1:            ; error, no parent label
END
test_t_local_labels_t.asm:4: error: local label without normal label before it: @l1
  ^---- @l1: ; error, no parent label
      ^---- @l1:
END


z80asm_ok("", "", "", <<'END',
g1:				; 0x0000
    jp g1
@l1:			; 0x0003
    jp @l1
    jp @l2		
    jp g1@l1    
    jp g1@l2    
@l2:			; 0x000F
END
		bytes(0xC3).words(0x0000).
		bytes(0xC3).words(0x0003).
		bytes(0xC3).words(0x000F).
		bytes(0xC3).words(0x0003).
		bytes(0xC3).words(0x000F));


unlink_testfiles;
done_testing;
