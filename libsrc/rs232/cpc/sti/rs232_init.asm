;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_init()
;
;       $Id: rs232_init.asm,v 1.2 2008-06-05 14:31:24 stefano Exp $

                XLIB   rs232_init
                
rs232_init:

        ld  hl,0        ;RS_ERR_OK;
        ret
