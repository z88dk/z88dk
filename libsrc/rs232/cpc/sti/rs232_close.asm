;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_close()
;


                XLIB   rs232_close
                
rs232_close:

        ld  hl,0        ;RS_ERR_OK;
        ret
