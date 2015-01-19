;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $


                PUBLIC   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
