;
;       z88dk RS232 Function
;
;       OSCA version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
                PUBLIC   rs232_close
                PUBLIC   _rs232_close
                
rs232_close:
_rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
