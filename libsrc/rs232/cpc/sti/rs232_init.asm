;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_init()
;
;       $Id: rs232_init.asm,v 1.5 2017-01-03 00:14:08 aralbrec Exp $

		SECTION  code_clib
                PUBLIC   rs232_init
                PUBLIC   _rs232_init
                
rs232_init:
_rs232_init:

        ld  hl,0        ;RS_ERR_OK;
        ret
