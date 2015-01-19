;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_put(char)
;
;       $Id: rs232_put.asm,v 1.4 2015-01-19 01:33:07 pauloscustodio Exp $

; Fastcall so implicit push


                PUBLIC   rs232_put

rs232_put:
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


