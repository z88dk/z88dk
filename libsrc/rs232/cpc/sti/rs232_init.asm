;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_init()
;

                XLIB   rs232_init
                
rs232_init:

	ld  hl,0	;RS_ERR_OK;
	ret
