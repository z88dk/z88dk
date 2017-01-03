;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_put(char)
;
;       $Id: rs232_put.asm,v 1.6 2017-01-03 00:14:08 aralbrec Exp $

; Fastcall so implicit push

		SECTION  code_clib
                PUBLIC   rs232_put
                PUBLIC   _rs232_put

rs232_put:
_rs232_put:
                ld   bc,$f8ee

wait:           in   a,(c)
                bit  7,a
                jr   z,wait
                ld   c,$e1
cts:            in   a,(c)
                bit  2,a
                jr   nz,cts

                ld      a,l     ;get byte
                ld   c,$ef
                out  (c),a

                ld   hl,0       ;RS_ERR_OK
                ret


