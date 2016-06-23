;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_get(char *)
;
;       $Id: rs232_get.asm,v 1.4 2016-06-23 20:15:37 dom Exp $

;       fastcall so implicit push

		SECTION  code_clib
                PUBLIC   rs232_get
                PUBLIC   _rs232_get
                
rs232_get:     
_rs232_get:     
		ld   bc,$f8e1
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

                ld      (hl),a
                ld      hl,0            ; RS_ERR_OK

                ;;; ld  hl,RS_ERR_NO_DATA

                ret
