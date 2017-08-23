;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_put(char)
;
;       $Id: rs232_put.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

; Fastcall so implicit push

		SECTION  code_clib
                PUBLIC   rs232_put
                PUBLIC   _rs232_put

rs232_put:	
_rs232_put:	
		ld bc, $FF08
		ld a, l
		out (c), a
				
		ld hl, 0
		ret
				
