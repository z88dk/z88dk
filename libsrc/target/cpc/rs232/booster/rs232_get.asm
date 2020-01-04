;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_get(char *)
;
;       $Id: rs232_get.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

;       fastcall so implicit push

		SECTION  code_clib
                PUBLIC   rs232_get
                PUBLIC   _rs232_get
                
rs232_get:      
_rs232_get:      
		ld bc, $FF1C
nowort:		in a, (c)
		or a
		jr z, nowort
				
		;read data word
		inc c				;&FF1D
		in a, (c)
		ld (hl), a			;put data into the pointer supplied
				
		ld hl, 0            ; RS_ERR_OK
		ret

