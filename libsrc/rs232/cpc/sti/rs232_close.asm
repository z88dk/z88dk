;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.2 2008-06-05 14:31:24 stefano Exp $


                XLIB   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
