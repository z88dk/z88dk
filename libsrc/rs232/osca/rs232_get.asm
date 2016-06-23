;
;       z88dk RS232 Function
;
;       OSCA version
;
;       unsigned char rs232_get(char *)
;
;       $Id: rs232_get.asm,v 1.4 2016-06-23 20:15:37 dom Exp $


; __FASTCALL__
			SECTION  code_clib
			PUBLIC   rs232_get
			PUBLIC   _rs232_get
			
			INCLUDE "osca.def"

rs232_get:
_rs232_get:
	
			ld b,50
.wait_sb
			in a,(sys_joy_com_flags)		; if bit 6 of status flags = 1, byte is in buffer 
			bit 6,a
			jr nz,sbyte_in
			in a,(sys_irq_ps2_flags)
			and 4				; if bit 2 of status flags = 1, timer has overflowed
			jr z,wait_sb
			out (sys_clear_irq_flags),a		; clear timer overflow flag
			djnz wait_sb

			ld	hl,4	; RS_ERR_NO_DATA
						; time out after 0.2 seconds
			ret
			
.sbyte_in
			in a,(sys_serial_port)		; get serial byte in A - this also clears bit 6 of status flags

			ld      (hl),a
			ld      hl,0            ; RS_ERR_OK
			ret
