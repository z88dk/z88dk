;
;       z88dk RS232 Function
;
;       OSCA version
;
;       unsigned char rs232_put(char)
;
;       $Id: rs232_put.asm,v 1.4 2016-07-29 03:28:48 pauloscustodio Exp $

; __FASTCALL__

		SECTION code_clib
		PUBLIC   rs232_put
		PUBLIC   _rs232_put

		INCLUDE "osca.def"

rs232_put:
_rs232_put:

			ld c,2
.s_wait
			in a,(sys_joy_com_flags)		; ensure no byte is still being transmitted
			bit 7,a
			jr nz,s_wait

			ld a,l
			out (sys_serial_port),a

			;ld b,32				; limit send speed (gap between bytes)
			ld b,20				; limit send speed (gap between bytes)
.ssplim
			djnz ssplim

			ld   hl,0       ;RS_ERR_OK
			ret
