;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_put(char)
;
;       $Id: rs232_put.asm,v 1.2 2015-01-21 14:00:11 stefano Exp $

; Fastcall so implicit push


                PUBLIC   rs232_put

rs232_put:		ld bc, $FF08
				ld a, l
				out (c), a
				
				ld hl, 0
				ret
				