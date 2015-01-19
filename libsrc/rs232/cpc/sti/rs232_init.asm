;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_init()
;
;       $Id: rs232_init.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $

                PUBLIC   rs232_init
                
rs232_init:

        ld  hl,0        ;RS_ERR_OK;
        ret
