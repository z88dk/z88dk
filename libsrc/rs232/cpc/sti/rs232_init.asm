;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_init()
;
;       $Id: rs232_init.asm,v 1.4 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
                PUBLIC   rs232_init
                
rs232_init:
_rs232_init:

        ld  hl,0        ;RS_ERR_OK;
        ret
