;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.1 2008-07-18 07:51:12 stefano Exp $


                XLIB   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
