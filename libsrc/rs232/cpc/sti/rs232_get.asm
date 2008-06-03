;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_get(char *)
;

;	fastcall so implicit push


                XLIB   rs232_get
                
rs232_get:      ld   bc,$f8e1
                xor  a
                out  (c),a
                ld   c,$ed
nowort:         in   a,(c)
                bit  7,a
                jr   z,nowort
                ld   c,$ef
                in   a,(c)
                ld   c,$e1
                ld   e,1
                out  (c),e

		ld	(hl),a
		ld	hl,0		; RS_ERR_OK

		;;; ld	hl,RS_ERR_NO_DATA

		ret
