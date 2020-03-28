;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_init()
;
;       $Id: rs232_init.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
                PUBLIC   rs232_init
                PUBLIC   _rs232_init
                
rs232_init:
_rs232_init:
		;check if CPC Booster+ is connected
		ld bc, $FF00	;Testbytes / Reset
		in a, (c)
		cp $AA			;Testbyte 1 -> always 0xAA
		jr nz, rs232_initerror

		inc bc
		in a, (c)
		cp $55			;Testbyte 2 -> always 0x55
		jr nz, rs232_initerror
		
		;Booster available, now enable buffering and disable double UART speed (bit 3=0)
		ld c, $0B		;&FF0B
		ld a, $10
		out (c), a		;set bit 4
		
		;Reset the input buffer
		ld c, $1C		;&FF1C <- 1
		ld a, 1
		out (c),a
		
    		ld  hl,0        ;RS_ERR_OK;
        	ret
		
rs232_initerror:
		ld hl,1			;RS_ERR_NOT_INITIALIZED
		ret
