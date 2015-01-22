;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.2 2015-01-22 12:09:57 stefano Exp $


                PUBLIC   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
