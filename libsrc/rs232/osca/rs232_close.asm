;
;       z88dk RS232 Function
;
;       OSCA version
;
;       unsigned char rs232_close()
;
;       $Id: rs232_close.asm,v 1.1 2012-06-26 06:11:23 stefano Exp $


                XLIB   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
